class ArticoliController < ApplicationController
 
  def create
    @cliente = Cliente.find(params[:cliente_id])
    @cliente.articolo.build(params[:articolo])
  end
  
end
