# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :documento do
    tipo "MyString"
    data "2012-08-11"
    importo "9.99"
  end
end
