class CassaController < ApplicationController
  
  authorize_resource :class => false
  
  def index
    @movimento = Movimento.new(tipo: "vendita")
    
    @movimenti = current_user.movimenti.vendita.attivo.includes(:articolo).all
    
    @incassi = Documento.cassa.recente.limit(5)
    
    @incassi_giornalieri = Documento.cassa.select(:data).order("data desc").group(:data).sum(:importo)
  end

end
