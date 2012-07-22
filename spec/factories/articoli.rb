# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :articolo do
    nome "MyString"
    quantita 1
    prezzo "9.99"
    provvigione 1
    cliente_id 1
    categoria_id 1
  end
end
