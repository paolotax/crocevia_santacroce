class User < ActiveRecord::Base
	rolify
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         
         :omniauthable

  attr_accessor :login

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :email, :password, :login, :password_confirmation, :remember_me, :provider, :uid, :role_ids

  has_many :movimenti
  
  acts_as_messageable
  
  # http://rails-bestpractices.com/posts/47-fetch-current-user-in-models solution
  # violates MVC pattern
  # def self.current
  #   Thread.current[:user]
  # end
  
  # def self.current=(user)
  #   Thread.current[:user] = user
  # end

  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(["lower(name) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    else
      where(conditions).first
    end
  end
      
  
  def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
    user = User.where(:provider => auth.provider, :uid => auth.uid).first
    unless user
      user = User.create(name:auth.extra.raw_info.name,
                           provider:auth.provider,
                           uid:auth.uid,
                           email:auth.info.email,
                           password:Devise.friendly_token[0,20]
                        )
    end
    user
  end
end
