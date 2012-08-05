# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
# puts 'SETTING UP DEFAULT USER LOGIN'
# user = User.create! :name => 'First User', :email => 'user@example.com', :password => 'please', :password_confirmation => 'please'
# puts 'New user created: ' << user.name
# user2 = User.create! :name => 'Second User', :email => 'user2@example.com', :password => 'please', :password_confirmation => 'please'
# puts 'New user created: ' << user2.name
# user.add_role :admin


50.times do
  @cliente = Cliente.create nome: "#{Faker::Name.first_name}", 
    cognome:    "#{Faker::Name.last_name}", 
    indirizzo:  "#{Faker::Address.street_address}", 
    citta:      "#{Faker::Address.city}", 
    provincia:  "#{Faker::Address.us_state}", 
    cap:        "#{Faker::Address.zip_code}"
  
  3.times do
    Articolo.create cliente_id: "#{@cliente.id}",
      nome: "#{"camicia pantalone gonna giacca gile' scarpe stivali cappello maglione felpa mutande calze abito".split.shuffle[0] }",
      prezzo: "#{rand(25)}",
      quantita: 1,
      provvigione: 50
  end

  3.times do
    Articolo.create cliente_id: @cliente.id,
      nome: "#{"divano poltrona sedia tavolo cucina como' ".split.shuffle[0] }",
      prezzo: [10,45,50,90,120,150,200,34.5].shuffle[0],
      quantita: 1,
      provvigione: 65
  end
      
end