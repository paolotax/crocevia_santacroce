class HomeController < ApplicationController
  
  def index
    @users = User.all
  end
  
  def regolamento
  end
  
  def staff
  end
  
end
