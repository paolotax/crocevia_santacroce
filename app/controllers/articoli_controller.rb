class ArticoliController < ApplicationController
 
  def create
    @articolo = Articolo.create(params[:articolo])
    redirect_to @articolo.cliente
  end
  
end
