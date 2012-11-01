require "prawn/measurement_extensions"


class DocumentoPdf < Prawn::Document
  
  include LayoutPdf
  
  def initialize(documenti, view)
    
    super(page_size:   'A4', 
          page_layout: :portrait, 
          margin:      [5.mm, 5.mm, 5.mm, 5.mm],
          info: {
              :Title => "etichette",
              :Author => "crocevia-santacroce",
              :Subject => "etichette",
              :Keywords => "etichette articoli crocevia",
              :Creator => "crocevia",
              :Producer => "Prawn",
              :CreationDate => Time.now
          })


    @documenti = documenti
    @view = view
     
    @documenti.each do |documento|
      default_header
      send("stampa_#{documento.tipo}", documento)
    end
    # start_new_page unless page_number >= @articoli.size.to_f / @labels_per_page
  end
  
  def stampa_resa(documento)
    intestazione(documento.mandante, "RESA Nr. #{documento.id} del #{documento.data.strftime('%d/%m/%Y')} CLIENTE #{documento.mandante.id}")
    table_cassa(documento.righe)
  end

  def stampa_cassa(documento)
    text "CASSA Nr. #{documento.id} del #{documento.data.strftime('%d/%m/%Y')}"
    table_cassa(documento.righe)
  end

  def stampa_rimborso(documento)
    intestazione(documento.mandante, "RIMESSA INCASSI Nr. #{documento.id} del #{documento.data.strftime('%d/%m/%Y')} CLIENTE #{documento.mandante.id}")
    table_vendite(documento.righe)
    firme_vendite
  end

  def stampa_carico(documento)
    intestazione(documento.mandante, "LISTA OGGETTI RICEVUTI DA CLIENTE N. #{documento.mandante.id}")
    table_articoli(documento.righe, false)
    firme_articoli(documento.data)
  end
    
end