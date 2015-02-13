class Notifier < ActionMailer::Base
  default from: "mercatino@crocevia-santacroce.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.notifier.vendita_added.subject
  #
  def vendita_added(vendita)
    @vendita = vendita

    mail to: "paolo.tassinari@gmail.com",
      subject: "Si sboccia!"
      
  end


  def riepilogo_giornata
    
    @vendite_di_oggi = Movimento.vendita.joins(:documento).includes(:articolo).where("documenti.data = ?", Time.zone.now.to_date )
    

    mail to: "marziabert@gmail.com", subject: "Riepilogo Crocevia"
      
  end

end
