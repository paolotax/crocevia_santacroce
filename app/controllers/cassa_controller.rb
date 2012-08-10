class CassaController < ApplicationController
  
  authorize_resource :class => false
  
  def index
    @movimento = Movimento.new(tipo: "vendita")
    
    @movimenti = Movimento.includes(:articolo).all
  end

end
