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
end
