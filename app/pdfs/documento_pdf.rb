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
    

      
    #cstart_new_page unless page_number >= @articoli.size.to_f / @labels_per_page
    
    
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
    table_articoli(documento.righe)
    firme_articoli(documento.data)
  end


  # def intestazione(documento)
  #   
  #   bounding_box [ bounds.left, bounds.top - 35.mm ], width: bounds.width do
  #     
  #     text "LISTA OGGETTI RICEVUTI DA CLIENTE N. #{documento.mandante.id}", style: :bold
  #     bounding_box [bounds.width / 2, bounds.top], width: bounds.width / 2 do
  #       text "MANDATO N. #{documento.mandante.id - 2} del #{documento.mandante.created_at.strftime('%d/%m/%Y')}", align: :right
  #     end
  #     bounding_box [ bounds.left, bounds.top - 7.mm], width: bounds.width do
  #       text "#{documento.mandante.to_s.upcase}", style: :bold
  #       bounding_box [bounds.width / 2, bounds.top], width: bounds.width / 2 do
  #         text "nato il #{documento.mandante.data_di_nascita_text} a #{documento.mandante.comune_di_nascita}", align: :right
  #       end
  #     end  
  #     move_down 5
  #     text "residente in: #{documento.mandante.indirizzo} - #{documento.mandante.cap} - #{documento.mandante.citta}   (#{documento.mandante.provincia})"
  #     move_down 5
  #     text "CF. #{documento.mandante.codice_fiscale} - P.IVA #{documento.mandante.partita_iva}"
  #   end
  # end    
    
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

  def line_item_rows(documento)
    [["Data Entr.", "N. Art.", "N. Dep.", "Descrizione", "Q.ta", "Prezzo un.", "Provv."]] +
      
      documento.articoli.order("articoli.id").map do |a|
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
  
  def riepilogo(documento)
    
    move_down 1
    stroke_line [bounds.left, cursor], [bounds.right, cursor]
    left = bounds.left + 100.mm - 2
    bounding_box [left, cursor - 3], width: bounds.right - left do
      
      bounding_box [bounds.left, bounds.top], width: 35.mm do
        text "Totale Articoli", size: 9
        move_down 2
        text "Realizzo (*)", size: 9
      end
      
      bounding_box [bounds.left + 35.mm, bounds.top], width: 20.mm do
        text documento.numero_articoli.to_s, align: :right, size: 9
      end
      
      bounding_box [bounds.left + 55.mm, bounds.top], width: 25.mm do
        text price(documento.importo_carico), align: :right, size: 9
      end
      
      bounding_box [bounds.left + 80.mm, bounds.top], width: 20.mm do
        text price(documento.provvigione), align: :right, size: 9
      end
      
      bounding_box [bounds.left + 70.mm, bounds.top - 3.mm - 3], width: 20.mm do
        text price(documento.realizzo), align: :right, size: 9, style: :bold
      end
    end
  end

  def firme(documento)
    move_down 5.mm
    
    bounding_box [bounds.left, cursor], width: bounds.width do
    
      bounding_box [bounds.left, bounds.top], width: 55.mm do
        text "BOLOGNA", size: 9
        move_down 3.mm
        text "Per accettazione dell'incarico e ricevuta oggetti in conto deposito", size: 9
        move_down 5.mm
        text "Il Mandatario", size: 9
        move_down 10.mm
        stroke_horizontal_rule
      end
    
      bounding_box [bounds.left + 60.mm, bounds.top], width: 55.mm do
        text documento.data.strftime("%d/%m/%Y"), size: 9
        move_down 3.mm
        text "Per conferma degli oggetti in vendita alle condizioni del Mandato vendita", size: 9
        move_down 5.mm
        text "Il Mandante", size: 9
        move_down 10.mm
        stroke_horizontal_rule
      end    
      
      move_down 10.mm
      
      text "(*) Nota Bene:", size: 9
      text "Realizzo massimo in caso di vendita di tutti gli oggetti, senza ribasso del prezzo di entrata.", size: 9
    end
  end


    
end