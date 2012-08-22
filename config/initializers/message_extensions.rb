Message.class_eval do
  has_many :photos, dependent: :destroy
  
  def peperoni
    puts "peperoni fritti"
  end
end