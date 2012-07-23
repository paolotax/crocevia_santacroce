class ArticoliController < ApplicationController
 
  def create
    @articolo = Articolo.create(params[:articolo])
    
    respond_to do |format|
      format.html { redirect_to @articolo.cliente }
      format.js
    end
  end
  
  def destroy
    @articolo = Articolo.find(params[:id])
    @articolo.destroy

    respond_to do |format|
      format.html { redirect_to @articolo.cliente }
      format.js
    end
  end

end
