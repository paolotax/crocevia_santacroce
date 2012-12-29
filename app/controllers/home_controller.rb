class HomeController < ApplicationController
  
  def index
    @photos = Photo.disponibili
  end
  
  def regolamento
  end
  
  def staff
  end
  
  def dove_siamo
  end
  
  def welcome
  end
end
