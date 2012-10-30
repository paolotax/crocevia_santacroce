require "prawn/measurement_extensions"


class SituazioneClientePdf < Prawn::Document
  
  include LayoutPdf
  
  def initialize(cliente, view)

    super(page_size:   'A4', 
          page_layout: :portrait, 
          margin:      [5.mm, 5.mm, 5.mm, 5.mm],
          info: {
              :Title => "situazione cliente",
              :Author => "crocevia-santacroce",
              :Subject => "situazione",
              :Keywords => "situazione cliente crocevia",
              :Creator => "crocevia",
              :Producer => "Prawn",
              :CreationDate => Time.now
          })

    @cliente = cliente
    @view = view

    @carichi = @cliente.articoli.registrato.disponibili.order("articoli.id")
    default_header
    intestazione(@cliente, "LISTA OGGETTI IN CARICO DA CLIENTE #{@cliente.id}")  
    table_articoli(@carichi)
    firme_articoli(Time.zone.now)

    start_new_page

    @vendite = @cliente.movimenti.registrato.vendita.da_rimborsare.joins(:documento).order("documenti.data")
    default_header
    intestazione(@cliente, "VENDUTO CLIENTE #{@cliente.id}")  
    table_vendite(@vendite)
  end


end