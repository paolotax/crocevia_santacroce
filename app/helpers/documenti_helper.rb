module DocumentiHelper

  def totale_importo(values, tipo="cassa")
    importo = values.flatten.select{ |m| m.send("#{tipo}?")}.sum(&:importo)
    content_tag :td, class: "mese totale_#{tipo}", colspan: 2 do
      if importo > 0 
        raw(
            "#{tipo}" + 
            content_tag(:h4, number_to_currency(importo, locale: :it))
            )
      else
        ""
      end  
    end
  end

end