class CassaController < ApplicationController
  
  authorize_resource :class => false
  
  def index
    @movimento           = Movimento.new(tipo: "vendita")
    @movimenti           = current_user.movimenti.vendita.attivo.includes(:articolo).all
    
    #stats
    # @incassi             = Documento.recente.limit(5)
    # @incassi_settimana   = Documento.settimana.cassa.select(:data).order("data desc").group(:data).sum(:importo)
    # @incassi_mese        = Documento.cassa.order("data desc").group_by {|d| d.data.beginning_of_month }
    
    # @incasso_totale      = Documento.cassa.sum(&:importo)

    # @provvigione_clienti = Movimento.vendita.sum(&:importo_provvigione)
    # @da_rimborsare       = Movimento.rimborsabile.sum(&:importo_provvigione)
    # @rimborsi            = Movimento.rimborsato.sum(&:importo_provvigione)
    # @rimborsi_futuri     = Movimento.vendita.mese_in_corso.sum(&:importo_provvigione)

    # @patate              = @incasso_totale - @provvigione_clienti

    # @patate_in_corso     = Movimento.vendita.mese_in_corso.sum(&:ricavo)
    # @patate_scorse       = Movimento.vendita.mese_scorso.sum(&:ricavo) 
    # @patate_mangiate     = Movimento.vendita.mesi_passati.sum(&:ricavo) 
  
  end

end
