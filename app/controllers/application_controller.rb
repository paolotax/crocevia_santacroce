class ApplicationController < ActionController::Base
  
  protect_from_forgery
  
  # http://rails-bestpractices.com/posts/47-fetch-current-user-in-models solution
  # violates MVC pattern
  # def set_current_user
  #   User.current = current_user
  # end

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, :alert => exception.message
  end
end
