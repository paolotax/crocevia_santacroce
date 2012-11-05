# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :articolo do
    nome "Gino"
    quantita 1
    prezzo "9.99"
    provvigione 80
    association :cliente
    categoria_id 1
  end
end
