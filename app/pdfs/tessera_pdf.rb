require "prawn/measurement_extensions"

class TesseraPdf < Prawn::Document
  
  def initialize(cliente, view, options = {})
    
    defaults = {
      page_layout:   :landscape,
      page_size:     [25.mm, 54.mm],
      top_margin:    1.mm,
      left_margin:   4.mm,
      bottom_margin: 1.mm,
      right_margin:  4.mm
    }

    options = options.reverse_merge(defaults)

    super(page_size:     options[:page_size], 
          page_layout:   options[:page_layout], 
          top_margin:    options[:top_margin],
          left_margin:   options[:left_margin],
          bottom_margin: options[:bottom_margin],
          right_margin:  options[:right_margin],
          info: {
              :Title => "tessera",
              :Author => "crocevia-santacroce",
              :Subject => "etichette",
              :Keywords => "tessera cliente crocevia",
              :Creator => "crocevia",
              :Producer => "Prawn",
              :CreationDate => Time.now
          })

    @view = view
    tessera cliente
    
  end  
    
  def tessera(cliente)
    
    font_size 9
    
    bounding_box [ bounds.left, bounds.top - 3.mm ], :width => bounds.width do
      #stroke_bounds
      text cliente.id.to_s
      text cliente.full_name.upcase, style: :bold
      text cliente.indirizzo
      text "#{cliente.cap} #{cliente.citta} #{cliente.provincia}"
      barcode =  "#{Rails.root}/public/barcodes/tessera_#{cliente.id}.png" 
      
      image barcode, :width => 30.mm, :height => 7.mm, :at => [bounds.left, bounds.top - 17.mm]
      
    end
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