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

if User.all.empty?
  user = User.create! :name => 'Paolo Tassinari', :email => 'ptax@crocevia-santacroce.com', :password => 'ptax', :password_confirmation => 'ptax'
  user.add_role :admin

  user_2 = User.create! :name => 'Marzia Bertoncelli', :email => 'mbert@crocevia-santacroce.com', :password => 'mbert', :password_confirmation => 'mbert'

  user_2.add_role :staff
end

rand(1000).times do
  @cliente = Cliente.create nome: "#{Faker::Name.first_name}", 
    cognome:    "#{Faker::Name.last_name}", 
    indirizzo:  "#{Faker::Address.street_address}", 
    citta:      "#{Faker::Address.city}", 
    provincia:  "#{Faker::Address.us_state}", 
    cap:        "#{Faker::Address.zip_code}",
    tipo_documento: "#{['patente',  'passaporto', 'carta'].shuffle[0]}",
    numero_documento:  "#{Faker::Address.zip_code}",
    comune_di_nascita: "#{Faker::Address.city}",
    sesso:              "#{'m f'.split.shuffle[0]}",

    documento_rilasciato_da: "#{'comune questura prefetto'.split.shuffle[0]} di #{Faker::Address.city}",
    data_rilascio_documento_text: "21-12-2005",
    data_di_nascita_text: "31-07-1965"
  
  
  rand(10).times do
    Articolo.create cliente_id: "#{@cliente.id}",
      nome: "#{"camicia pantalone gonna giacca gile' scarpe stivali cappello maglione felpa mutande calze abito".split.shuffle[0] } #{"blu giallo grigio vintage anni70 anni80 anni90 verde celeste nero spaziale".split.shuffle[0] }",
      prezzo: "#{rand(25)}",
      quantita: 1,
      provvigione: 50
  end

  rand(10).times do
    Articolo.create cliente_id: @cliente.id,
      nome: "#{"divano poltrona sedia tavolo cucina como' ".split.shuffle[0]} #{"rococo anni70 cippendale liberty anni50 pop' ".split.shuffle[0]}",
      prezzo: [10,45,50,90,120,150,200,34.5].shuffle[0],
      quantita: 1,
      provvigione: 65
  end
      
end