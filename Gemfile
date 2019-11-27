source 'https://rubygems.org'

ruby '2.3.7'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.7.1'

#DATABASE
# Use mysql2 as the database for Active Record
#gem 'mysql2'
gem 'mysql2', '< 0.5'

# Use 'foreigner' to add foreign_key constraints on database layer !
# https://github.com/matthuhiggins/foreigner
# gem 'foreigner'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
gem 'execjs'


#Documentation
gem 'annotate', '~> 2.6.6'

# Use jquery as the JavaScript library
gem 'jquery-rails'
gem 'jquery-ui-rails'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

# Authentification
gem 'devise', '~> 4.7.1'
gem 'omniauth'
gem "omniauth-cas", :git => "https://github.com/loocla/omniauth-cas.git", :branch => 'saml'
gem 'devise_masquerade'

# Authorisation
gem 'cancancan'

# API GRAM
gem 'activeresource', '~> 4.0.0'

gem 'email_validator'



# Templates
gem 'haml-rails'

# Forms
gem 'simple_form'
gem 'virtus'

# Pagination
gem 'will_paginate', '~> 3.0.0'

#Autocompletion pour les form de recherche
gem 'rails4-autocomplete'

# i18n pour les conversion d'accents
gem 'i18n'

# better flash messaages
gem 'unobtrusive_flash', '>=3'

# forconfiguration tables
gem 'configurable_engine', github: 'Blaked84/configurable_engine'

# tooltips
gem 'bootstrap-tooltip-rails'

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

gem 'google-api-client', '~> 0.9'

# Gadz.org Gems Gram v2 client
gem 'gram_v2_client', '~> 3.0'


gem 'gorg_service', '~>6.0'

gem 'gorg_slack_chat'

# For HTML mails
gem 'premailer-rails'
gem 'nokogiri'

gem 'puma'
gem 'scout_apm'

gem 'activerecord-import'

gem 'materialize-sass'
gem 'simple_form-materialize', github: 'patricklindsay/simple_form-materialize'


group :production do
  gem 'rails_12factor'
  gem 'heroku_secrets', github: 'alexpeattie/heroku_secrets'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'
  gem 'better_errors'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  # gem 'spring'
end


group :development, :test do
  # Use sqlite3 as the database for Active Record
  gem 'sqlite3'
  gem 'therubyracer', :platforms => :ruby
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'

  gem "letter_opener"

  #pour les diagramme UML
  gem 'rails-erd'

  #better cli table view for db
  gem 'hirb'

  # export db en yaml
  gem 'yaml_db', github: 'jetthoughts/yaml_db', ref: 'fb4b6bd7e12de3cffa93e0a298a1e5253d7e92ba'

  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'faker'
  gem 'quiet_assets'
  gem 'rack-mini-profiler'

end

group :test do
  gem 'cucumber-rails', :require => false
  gem 'capybara'
  gem 'selenium'
  gem 'selenium-webdriver'
  gem 'poltergeist'
  gem 'phantomjs', require: 'phantomjs/poltergeist'

  gem 'launchy'
  gem 'shoulda-matchers', '~> 3.0'
  gem 'database_cleaner'
  gem 'bogus'
  gem 'webmock'
end
