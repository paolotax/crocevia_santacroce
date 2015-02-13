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

    @in_carico = @carichi.select { |v| !(v.patate? == true)}
    unless @in_carico.empty?
      default_header
      intestazione(@cliente, "LISTA OGGETTI IN CARICO DA CLIENTE #{@cliente.id}")  
      table_articoli(@in_carico)
      firme_articoli(Time.zone.now)
    end
    
    # @da_discaricare = @carichi.select { |v| (v.patate? == true)}
    # unless @da_discaricare.empty?
    #   start_new_page
    #   #default_header
    #   intestazione(@cliente, "OGGETTI DA DISCARICARE - CLIENTE #{@cliente.id}")  
    #   table_articoli(@da_discaricare)
    # end

    @vendite = @cliente.movimenti
                       .registrato
                       .vendita
                       .da_rimborsare
                       .joins(:documento)
                       .order("documenti.data, movimenti.id").select { |v| !(v.patate? == true)}
    
    unless @vendite.empty?
      start_new_page
      default_header
      intestazione(@cliente, "VENDUTO CLIENTE #{@cliente.id}")  
      table_vendite(@vendite)
    end
  end


end