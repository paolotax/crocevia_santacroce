class CassaController < ApplicationController
  
  authorize_resource :class => false
  
  def index
    @movimento = Movimento.new(tipo: "vendita")
    
    @movimenti = current_user.movimenti.attivo.includes(:articolo).all
  end

end
