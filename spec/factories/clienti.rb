# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :cliente do
    nome "MyString"
    cognome "MyString"
    ragione_sociale "MyString"
    indirizzo "MyString"
    cap "MyString"
    citta "MyString"
    provincia "MyString"
    partita_iva "MyString"
    codice_fiscale "MyString"
    tipo_documento "MyString"
    numero_documento "MyString"
    scadenza_documento "2012-07-01"
    numero_tessera "MyString"
  end
end
