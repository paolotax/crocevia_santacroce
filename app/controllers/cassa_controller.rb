class CassaController < ApplicationController
  
  authorize_resource :class => false
  
  def index
    @movimento           = Movimento.new(tipo: "vendita")
    @movimenti           = current_user.movimenti.vendita.attivo.includes(:articolo).all
    
    calc_vendite  
  end

  
  def stats
    calc_all_stats
  end

  
  private

    
    def calc_vendite
      @incassi             = Documento.recente.limit(10)
      
      @incassi_giorno      = Documento.cassa.where(data: Time.now).sum(:importo)
      
      @incassi_settimana   = Documento.settimana.cassa.select(:data).order("data desc").group(:data).sum(:importo)
      @incassi_mese        = Documento.cassa.order("data desc").group_by {|d| d.data.beginning_of_month }

    end

    
    def calc_all_stats

      calc_vendite
    
      @incasso_totale      = Documento.cassa.sum(&:importo)
      
      @provvigione_clienti = Movimento.vendita.sum(&:importo_provvigione)
      @da_rimborsare       = Movimento.rimborsabile.sum(&:importo_provvigione)
      @rimborsi            = Movimento.rimborsato.sum(&:importo_provvigione)
      @rimborsi_futuri     = Movimento.vendita.mese_in_corso.sum(&:importo_provvigione)

      @patate              = @incasso_totale - @provvigione_clienti

      @patate_in_corso     = Movimento.vendita.mese_in_corso.sum(&:ricavo)
      @patate_scorse       = Movimento.vendita.mese_scorso.sum(&:ricavo) 
      @patate_mangiate     = Movimento.vendita.mesi_passati.sum(&:ricavo) 
    end

end
