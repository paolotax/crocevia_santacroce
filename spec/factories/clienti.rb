# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :cliente do
    nome            "Paolo"
    cognome         "Tassinari"
    ragione_sociale "taxSoft"
    indirizzo       "Via Vestri, 4"
    cap             "40128"
    citta           "Bologna"
    provincia       "BO"
    partita_iva     "04155820378"
    codice_fiscale  "TSSPLA65L31A944U"
    tipo_documento  "identita"
    numero_documento "AAAAA"
    data_rilascio_documento "2012-07-01"
    documento_rilasciato_da "COmune di Bologna"
    numero_tessera    "MyString"
    data_di_nascita   "2012-07-01"
    comune_di_nascita "Bologna"
    sesso             "m"
  end
end
