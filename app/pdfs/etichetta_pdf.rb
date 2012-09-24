require "prawn/measurement_extensions"

class EtichettaPdf < Prawn::Document
  
  #include LayoutPdf
  
  def initialize(articoli, view, options = {})
    
    defaults = {
      page_layout:   :landscape,
      page_size:     [25.mm, 54.mm],
      top_margin:    0,
      left_margin:   2.mm,
      bottom_margin: 0,
      right_margin:  2.mm,
      columns:       1,
      labels_per_page: 1
    }

    options = options.reverse_merge(defaults)

    super(page_size:     options[:page_size], 
          page_layout:   options[:page_layout], 
          top_margin:    options[:top_margin],
          left_margin:   options[:left_margin],
          bottom_margin: options[:bottom_margin],
          right_margin:  options[:right_margin],
          info: {
              :Title => "etichette",
              :Author => "crocevia-santacroce",
              :Subject => "etichette",
              :Keywords => "etichette articoli crocevia",
              :Creator => "crocevia",
              :Producer => "Prawn",
              :CreationDate => Time.now
          })

    @labels_per_page = options[:labels_per_page]
    @columns         = options[:columns]
    @rows            = @labels_per_page / @columns
    
    @label_width  = bounds.width / @columns
    @label_height = (bounds.height) / @rows   
    
    @articoli = articoli
    @view = view
    
    if options[:start_from]
      (1..options[:start_from].to_i).each { @appunti.insert(0, nil) }
    end

    @articoli.in_groups_of( @labels_per_page, false ) do |pages|
      num_row = 0
      pages.in_groups_of(@columns, false) do |rows|
        rows.each_with_index do |a, index|
          if a
            etichetta(a, index, num_row)
          end
        end  
        num_row += 1
      end
      
      start_new_page unless page_number >= @articoli.size.to_f / @labels_per_page
    end
    
  end  
    
  def etichetta(articolo, num_etichetta, num_row)
    
    left = num_etichetta * @label_width
    top  =  bounds.top - (num_row * @label_height)
     
    bounding_box [ left, top ], :width => @label_width, :height => @label_height do
       #stroke_bounds
      barcode =  "#{Rails.root}/public/barcodes/barcode_#{articolo.id}.png" 
      image barcode, :width => 35.mm, :height => 10.mm, :at => [bounds.left, bounds.top]
      draw_text articolo.id.to_s, at: [bounds.left + 37.mm, bounds.top - 10.mm]
      draw_text articolo.nome,    at: [bounds.left,         bounds.top - 15.mm]
      draw_text price(articolo.prezzo),  at: [bounds.left,         bounds.top - 20.mm]
      draw_text articolo.created_at.strftime("%d/%m/%Y"), at: [bounds.left + 34.mm,         bounds.top - 19.mm],  :size => 9
      
      label_articolo(articolo)
    end
  end
  
  def label_articolo(articolo)

    # bounding_box [ bounds.left + @destinatario_left, bounds.top - @destinatario_top ], :width => 6.5.cm do
    #   
    #   text appunto.destinatario, :size => 14, :style => :bold, :spacing => 4
    #   move_down 2.mm
    #   #text "#{appunto.cliente.cognome} #{appunto.cliente.nome}",  :size => 14, :style => :bold, :spacing => 4      
    #   text appunto.cliente.ragione_sociale,  :size => 14, :style => :bold, :spacing => 4
    #   text appunto.cliente.indirizzo,  :size => 12
    #   text appunto.cliente.cap + ' ' + appunto.cliente.frazione  + ' ' + appunto.cliente.comune  + ' ' + appunto.cliente.provincia,  :size => 12
    # end
  end

  def price(num)
    @view.number_to_currency(num, :locale => :it, :format => "%n %u", :precision => 2)
  end
  
  def l(data)
    @view.l data, :format => :only_date
  end
  
  def t(data)
    @view.t data
  end


  def current_user
    @view.current_user
  end
    
end