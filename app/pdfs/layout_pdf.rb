module LayoutPdf
  
  require "prawn/measurement_extensions"

  def default_header
    logo = "#{Rails.root}/app/assets/images/crocevia232x81.png"
    image logo, :width => 60.mm, :height => 20.mm, :at => [bounds.left, bounds.top]
    draw_text "di Marzia Bertoncelli e Stefano Scifoni. Via Santa Croce 11/abcde - 40121 Bologna - tel. e fax 051.64.90.677", 
              at: [bounds.left, bounds.top - 25.mm],
              size: 10
    draw_text "email: mercatino@crocevia-santacroce.com. Web: crocevia-santacroce.com - P.IVA 03218281206",
              at: [bounds.left, bounds.top - 29.mm],
              size: 10
    stroke_line [bounds.left, bounds.top - 31.mm], [bounds.right, bounds.top - 31.mm]
    move_down 35.mm
  end

  def intestazione(cliente, title)
    font_size 10
    bounding_box [ bounds.left, cursor ], width: bounds.width do
    
      text title, style: :bold
      bounding_box [bounds.width / 2, bounds.top], width: bounds.width / 2 do
        text "MANDATO N. #{cliente.id - 2} del #{cliente.created_at.strftime('%d/%m/%Y')}", align: :right
      end
      bounding_box [ bounds.left, bounds.top - 7.mm], width: bounds.width do
        text "#{cliente.to_s.upcase}", style: :bold
        bounding_box [bounds.width / 2, bounds.top], width: bounds.width / 2 do
          if cliente.maschio?
            nato = "nato"
          else
            nato = "nata"
          end    
          text "#{nato} il #{cliente.data_di_nascita_text} a #{cliente.comune_di_nascita}", align: :right
        end
      end  
      move_down 5
      text "residente in: #{cliente.indirizzo} - #{cliente.cap} - #{cliente.citta}   (#{cliente.provincia})"
      move_down 5
      text "CF. #{cliente.codice_fiscale} - P.IVA #{cliente.partita_iva}"
    end
  end

  #articoli

  def table_articoli(collection)
    move_down 10
    table articoli_rows(collection), :cell_style => { :size => 9  } do
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
    riepilogo_articoli(collection)
  end

  def articoli_rows(collection)
    [["Data Entr.", "N.Art.", "N.Carico", "Descrizione", "Q.ta", "Prezzo un.", "Provv."]] +
      
      collection.map do |articolo|
      [
        articolo.documento.data.strftime("%d/%m/%Y"), 
        articolo.id,
        articolo.documento.id, 
        articolo.nome, 
        articolo.giacenza,
        price(articolo.prezzo),
        "#{articolo.provvigione}%"
      ]
    end
  end
  
  def riepilogo_articoli(collection)
    
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
        text collection.sum(&:giacenza).to_s, align: :right, size: 9
      end
      
      bounding_box [bounds.left + 55.mm, bounds.top], width: 25.mm do
        text price(collection.sum(&:importo)), align: :right, size: 9
      end
      
      bounding_box [bounds.left + 80.mm, bounds.top], width: 20.mm do
        text price(collection.sum(&:importo_provvigione)), align: :right, size: 9
      end
      
      bounding_box [bounds.left + 70.mm, bounds.top - 3.mm - 3], width: 20.mm do
        text price(collection.sum(&:ricavo)), align: :right, size: 9, style: :bold
      end
    end
  end

  def firme_articoli(data)
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
        text data.strftime("%d/%m/%Y"), size: 9
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

  #vendite

  def table_vendite(collection)
    move_down 10
    table vendite_rows(collection), :cell_style => { :size => 9  } do
      row(0).font_style = :bold
      cells.padding = 3
      cells.borders = []
      row(0).columns(0..7).borders = [:bottom, :top]
      columns(0..1).align = :left
      columns(4).align = :left
      columns(6).align = :center
      columns(2..3).align = :right
      columns(5).align = :right
      columns(7).align = :right
      
      columns(0).width    = 20.mm
      columns(1).width    = 70.mm
      columns(2).width    = 15.mm
      columns(3).width    = 10.mm
      columns(4).width    = 25.mm
      columns(5).width    = 25.mm
      columns(6).width    = 20.mm
      columns(7).width    = 15.mm
      
      self.row_colors = ["DDDDDD", "FFFFFF"]
      self.header = true
    end
    riepilogo_vendite(collection)
  end

  def vendite_rows(collection)
    [["Data", "Descrizione (da Lista Oggetti)", "Mand", "Q.ta", "Oper", "Prezzo Tot. (A)", "Provv. (B)", ""]] +
      
      collection.map do |movimento|
      [
        movimento.documento.data.strftime("%d/%m/%Y"), 
        "art.#{movimento.articolo.id} #{movimento.articolo.nome}",
        movimento.mandante.id - 2, 
        1, 
        "VEN/#{movimento.id}",
        price(movimento.prezzo),
        "#{movimento.articolo.provvigione}%",
        price(movimento.importo_provvigione)
      ]
    end
  end
  
  def riepilogo_vendite(collection)
    font_size 10
    move_down 1
    stroke_line [bounds.left, cursor], [bounds.right, cursor]
    bounding_box [bounds.left, cursor - 5], width: bounds.width do
      bounding_box [bounds.left, bounds.top], width: 105.mm do
        text "Totali:", align: :right
      end
      bounding_box [bounds.left + 105.mm, bounds.top], width: 10.mm - 2 do
        text collection.size.to_s, align: :right
      end
      bounding_box [bounds.left + 115.mm, bounds.top], width: 50.mm - 2 do
        text price(collection.sum(&:importo)), align: :right
      end
      bounding_box [bounds.left, bounds.top], width: bounds.width - 2 do
        text price(collection.sum(&:importo_provvigione)), align: :right
      end
      bounding_box [bounds.left, cursor], width: bounds.width do
        text "Saldo (A-B) : #{price(collection.sum(&:importo_provvigione))}", size: 11, style: :bold
      end
    end
  end

  def firme_vendite
    move_down 3.mm

    bounding_box [bounds.left, cursor], width: bounds.width do

      text "Dichiaro di aver ricevuto la somma a saldo, in contanti"
      move_down 3.mm
      text "Firma_____________________________________", align: :right
      move_down 3.mm
      text "Dichiaro di aver ricevuto la somma indicata a saldo a mezzo A.B."
      move_down 3.mm
      text "CODICE IBAN_____________________________________________"
      draw_text "Firma_____________________________________", at: [bounds.left + 118.mm, cursor + 2.mm - 2]
      
    end
  end

  #cassa

  def table_cassa(collection)
    move_down 10
    table cassa_rows(collection), :cell_style => { :size => 9  } do
      row(0).font_style = :bold
      cells.padding = 3
      cells.borders = []
      row(0).columns(0..5).borders = [:bottom, :top]
      columns(0..1).align = :left
      columns(4).align = :left
      columns(2..3).align = :right
      columns(5).align = :right

      columns(0).width    = 20.mm
      columns(1).width    = 70.mm
      columns(2).width    = 15.mm
      columns(3).width    = 10.mm
      columns(4).width    = 25.mm
      columns(5).width    = 60.mm
      
      self.row_colors = ["DDDDDD", "FFFFFF"]
      self.header = true
    end
    riepilogo_cassa(collection)
  end

  def cassa_rows(collection)
    [["Data", "Descrizione (da Lista Oggetti)", "Mand", "Q.ta", "Oper", "Prezzo Tot. (A)"]] +
      collection.map do |movimento|
      [
        movimento.documento.data.strftime("%d/%m/%Y"), 
        "art.#{movimento.articolo.id} #{movimento.articolo.nome}",
        movimento.mandante.id - 2, 
        1, 
        "VEN/#{movimento.id}",
        price(movimento.prezzo)
      ]
    end
  end

  def riepilogo_cassa(collection)
    font_size 10
    move_down 1
    stroke_line [bounds.left, cursor], [bounds.right, cursor]
    bounding_box [bounds.left, cursor - 5], width: bounds.width do
      bounding_box [bounds.left, bounds.top], width: 105.mm do
        text "Totali:", align: :right
      end
      bounding_box [bounds.left + 105.mm, bounds.top], width: 10.mm - 2 do
        text collection.size.to_s, align: :right
      end
      bounding_box [bounds.width - 50.mm, bounds.top], width: 50.mm - 2 do
        text price(collection.sum(&:importo)), align: :right
      end
      bounding_box [bounds.left, cursor], width: bounds.width do
        text "Totale : #{price(collection.sum(&:importo))}", size: 11, style: :bold
      end
    end
  end

  def firme_cassa
    move_down 3.mm

    bounding_box [bounds.left, cursor], width: bounds.width do

      text "Dichiaro di aver ricevuto la somma a saldo, in contanti"
      move_down 3.mm
      text "Firma_____________________________________", align: :right
      move_down 3.mm
      text "Dichiaro di aver ricevuto la somma indicata a saldo a mezzo A.B."
      move_down 3.mm
      text "CODICE IBAN_____________________________________________"
      draw_text "Firma_____________________________________", at: [bounds.left + 118.mm, cursor + 2.mm - 2]
      
    end
  end

  # utils

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