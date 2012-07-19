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


500.times do
  Cliente.create :nome => "#{Faker::Name.first_name}", cognome: "#{Faker::Name.last_name}", 
 
  indirizzo:  "#{Faker::Address.street_address}",
  citta:      "#{Faker::Address.city}",
  provincia:  "#{Faker::Address.us_state}",
  cap:        "#{Faker::Address.zip_code}"
end