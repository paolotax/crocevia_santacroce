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
  end

  def intestazione(cliente, title)
    font_size 10
    bounding_box [ bounds.left, bounds.top - 35.mm ], width: bounds.width do
    
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
end  