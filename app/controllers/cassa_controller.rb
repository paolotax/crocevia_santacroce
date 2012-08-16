class CassaController < ApplicationController
  
  authorize_resource :class => false
  
  def index
    @movimento = Movimento.new(tipo: "vendita")
    
    @movimenti = current_user.movimenti.attivo.includes(:articolo).all
    
    @incassi = Documento.cassa.recente.limit(5)
    
    @incassi_giornalieri = Documento.cassa.recente.group(:data).select("data, sum(importo) as importo")
  end

end
