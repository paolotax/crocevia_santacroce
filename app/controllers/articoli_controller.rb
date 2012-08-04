class ArticoliController < ApplicationController
  
  # load_and_authorize_resource
  
  def index
    @q = Articolo.includes(:cliente).order("id desc").page(params[:page]).per(30).search(params[:q])
    @articoli = @q.result(:distinct => true)
    # @search.build_condition if @search.conditions.empty?
    # @search.build_sort if @search.sorts.empty?
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
