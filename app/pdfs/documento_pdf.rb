require "prawn/measurement_extensions"

class DocumentoPdf < Prawn::Document
  
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
      logo
      intestazione(documento)
      line_items(documento)
    end
      
    #cstart_new_page unless page_number >= @articoli.size.to_f / @labels_per_page
    
    
  end
  
  def logo
    logo = "#{Rails.root}/app/assets/images/crocevia232x81.png"
    image logo, :width => 60.mm, :height => 20.mm, :at => [bounds.left, bounds.top]
    
    draw_text "di Marzia Bertoncelli e Stefano Scifoni. Via Santa Croce 11/abcde - 40121 Bologna - tel. e fax 051.64.90.677", 
              at: [bounds.left, bounds.top - 25.mm],
              size: 10
    draw_text "email: mercatino@crocevia-santacroce.com. Web: crocevia-santacroce.com - P.IVA 03218281206",
              at: [bounds.left, bounds.top - 29.mm],
              size: 10
    
    stroke_line [bounds.left, bounds.top - 31.mm], [bounds.right, bounds.top - 31.mm]
    
    
  end
  
  def intestazione(documento)
    
    bounding_box [ bounds.left, bounds.top - 35.mm ], width: bounds.width do
      
      text "LISTA OGGETTI RICEVUTI DA CLIENTE N. #{documento.mandante.id}", style: :bold
      bounding_box [bounds.width / 2, bounds.top], width: bounds.width / 2 do
        text "MANDATO N. #{documento.mandante.id - 2} del #{documento.mandante.created_at.strftime('%d/%m/%Y')}", align: :right
      end
      bounding_box [ bounds.left, bounds.top - 7.mm], width: bounds.width do
        text "#{documento.mandante.to_s.upcase}", style: :bold
        bounding_box [bounds.width / 2, bounds.top], width: bounds.width / 2 do
          text "nato il #{documento.mandante.data_di_nascita_text} a #{documento.mandante.comune_di_nascita}", align: :right
        end
      end  
      move_down 5
      text "residente in: #{documento.mandante.indirizzo} - #{documento.mandante.cap} - #{documento.mandante.citta}   (#{documento.mandante.provincia})"
      move_down 5
      text "CF. #{documento.mandante.codice_fiscale} - P.IVA #{documento.mandante.partita_iva}"
    end
  end    
    
  def line_items(documento)
    move_down 10
    table line_item_rows(documento), :cell_style => { :size => 9  } do
      row(0).font_style = :bold
      cells.padding = 3
      cells.borders = []
      row(0).columns(0..6).borders = [:bottom, :top]
      columns(0..3).align = :left
      columns(4..6).align = :right
      columns(0).width    = 25.mm
      columns(1..2).width = 20.mm
      columns(3).width    = 70.mm
      columns(4).width    = 20.mm
      columns(5).width    = 25.mm
      columns(6).width    = 20.mm
      self.row_colors = ["DDDDDD", "FFFFFF"]
      self.header = true
    end
    riepilogo(documento)
  end
  
  def riepilogo(documento)
    move_down 1
    stroke_line [bounds.left, cursor], [bounds.right, cursor]
    left = bounds.left + 135.mm - 3
    bounding_box [left, cursor - 3], width: bounds.right - left do
      bounding_box [bounds.left, bounds.top], width: 20.mm do
        text documento.numero_articoli.to_s, align: :right, size: 9
      end
      bounding_box [bounds.left + 20.mm, bounds.top], width: 25.mm do
        text price(documento.importo_carico), align: :right, size: 9
      end
      bounding_box [bounds.left + 45.mm, bounds.top], width: 20.mm do
        text price(documento.realizzo), align: :right, size: 9
      end
    end
  
  
  end

  def line_item_rows(documento)
    [["Data Entr.", "N. Art.", "N. Dep.", "Descrizione", "Q.ta", "Prezzo un.", "Provv."]] +
      
      documento.articoli.map do |a|
      [
        documento.data.strftime("%d/%m/%Y"), 
        a.id,
        "", 
        a.nome, 
        a.quantita,
        price(a.prezzo),
        "#{a.provvigione}%"
      ]
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