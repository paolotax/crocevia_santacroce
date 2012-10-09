class HomeController < ApplicationController
  
  def index
  end
  
  def regolamento
  end
  
  def staff
  end
  
  def dove_siamo
  end

  def upload_photo
    @photos = Photo.all
  end
  
  def welcome
  end
end
