source 'https://rubygems.org'

ruby '2.6.4'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '5.0.7.2'

#DATABASE
# Use mysql2 as the database for Active Record
gem 'mysql2', '< 0.5'

# Use 'foreigner' to add foreign_key constraints on database layer !
# https://github.com/matthuhiggins/foreigner
# gem 'foreigner'

# Use SCSS for stylesheets
gem 'sass-rails'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
gem 'execjs'


#Documentation
gem 'annotate'

# Use jquery as the JavaScript library
gem 'jquery-rails'
gem 'jquery-ui-rails'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', group: :doc

# Authentification
gem 'devise'
gem 'omniauth'
gem "omniauth-cas", git: "https://github.com/loocla/omniauth-cas", branch: 'saml'
gem 'devise_masquerade'

# Authorisation
gem 'cancancan'

# API GRAM
gem 'activeresource'

gem 'email_validator'



# Templates
gem 'haml-rails'

# Forms
gem 'simple_form'
gem 'virtus'

# Pagination
gem 'will_paginate'

#Autocompletion pour les form de recherche
gem 'rails4-autocomplete'

# i18n pour les conversion d'accents
gem 'i18n'

# better flash messaages
gem 'unobtrusive_flash'

# forconfiguration tables
gem 'configurable_engine', git: 'https://github.com/Blaked84/configurable_engine'

# tooltips
gem 'bootstrap-tooltip-rails'

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

gem 'google-api-client'

# Gadz.org Gems Gram v2 client
gem 'gram_v2_client', git: "https://github.com/gadzorg/gram2_api_client_ruby"


gem 'gorg_service'

# gem 'gorg_slack_chat', git: "https://github.com/gadzorg/gorg_slack_chat"

# For HTML mails
gem 'premailer-rails'
gem 'nokogiri'

gem 'puma'
gem 'scout_apm'

gem 'activerecord-import'

gem 'materialize-sass', '~> 0.100'

group :production do
  gem 'rails_12factor'
  gem 'heroku_secrets', git: "https://github.com/alexpeattie/heroku_secrets"
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console'
  gem "better_errors"
  gem "binding_of_caller"
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  # gem 'spring'
end


group :development, :test do
  gem "mini_racer"

  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem "pry-byebug"
  gem "pry-rails"

  gem "letter_opener"

  #pour les diagramme UML
  gem 'rails-erd'

  #better cli table view for db
  gem 'hirb'

  # export db en yaml
  gem 'yaml_db', git: "https://github.com/gadzorg/yaml_db"

  gem 'rspec-rails'
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'rack-mini-profiler'
end

group :test do
  gem 'cucumber-rails', require: false
  gem 'capybara'
  gem 'selenium'
  gem 'selenium-webdriver'
  gem 'poltergeist'
  gem 'phantomjs', require: 'phantomjs/poltergeist'

  gem 'launchy'
  gem 'shoulda-matchers'
  gem 'database_cleaner'
  gem 'webmock'
  gem 'simplecov'

  gem 'rails-controller-testing'
end
