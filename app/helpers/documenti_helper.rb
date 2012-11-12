module DocumentiHelper

  def importo_per_mese(values, tipo="cassa")

    content_tag :td, class: "mese totale_#{tipo}", colspan: 2 do
      raw(
          "#{tipo}" + 
          content_tag(:h4, number_to_currency(values.flatten.select{ |m| m.send("#{tipo}?")}.sum(&:importo)))
          )
    end 
  end

end