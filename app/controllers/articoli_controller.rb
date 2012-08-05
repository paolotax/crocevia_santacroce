class ArticoliController < ApplicationController
  
  # load_and_authorize_resource
  
  def index
    @q = Articolo.includes(:cliente).order("id desc").search(params[:q])
    @articoli = @q.result(:distinct => true).page(params[:page]).per(30)
  end
 
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
  
  def show
  end
  
end
