require 'rbconfig'
HOST_OS = RbConfig::CONFIG['host_os']
source 'https://rubygems.org'

gem 'rails', '3.2.5'
gem 'pg'

gem "barby"
gem "chunky_png"
gem "has_barcode"

group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
  gem 'jquery-ui-rails'
  gem "compass-rails"
  gem "jquery-fileupload-rails"
  gem 'anjlab-bootstrap-rails', '>= 2.1', :require => 'bootstrap-rails'
end

gem 'jquery-rails'
gem "haml", ">= 3.1.6"

group :development do
  gem "haml-rails", ">= 0.3.4"
  gem "rails-footnotes", ">= 3.7"
  # gem 'bullet'
end

group :development, :test do
  gem 'sqlite3'
  gem "rspec-rails", ">= 2.10.1"

  gem "guard", ">= 0.6.2" 
  gem "guard-bundler", ">= 0.1.3"
  gem "guard-rails", ">= 0.0.3"
  gem "guard-livereload", ">= 0.3.0"
  gem "guard-rspec", ">= 0.4.3"
  gem "guard-cucumber", ">= 0.6.1"
  gem "guard-spork" 
  gem "better_errors" 
  gem "binding_of_caller"
  gem 'meta_request'
end

group :test do
  gem "machinist"
  gem "email_spec", ">= 1.2.1"
  gem "cucumber-rails", ">= 1.3.0", :require => false
  gem "capybara", ">= 1.1.2"
  gem "database_cleaner", ">= 0.8.0"
  gem "factory_girl_rails", ">= 3.3.0"
  gem "launchy", ">= 2.1.0"
  gem 'shoulda'

  gem 'fuubar'

end


gem "kaminari"
gem "faker"
gem "friendly_id"
gem "ransack"

gem 'savon'
gem 'sexmachine'
gem 'mailboxer'


#gem 'ruby-vips'
#gem 'carrierwave-vips'


gem "devise", ">= 2.1.0"
gem "cancan", ">= 1.6.7"
gem "rolify", ">= 3.1.0"

gem "simple_form"

gem "turbolinks"
gem 'jquery-turbolinks'

gem 'best_in_place'

gem 'display_case', :git => "https://github.com/objects-on-rails/display-case.git"

gem 'prawn'

gem "omniauth-facebook"
gem 'font-awesome-sass-rails'

gem 'capistrano'
gem 'unicorn'


