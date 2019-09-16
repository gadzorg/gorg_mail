require_relative 'boot'

require 'rails/all'
require 'active_resource'


# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Imelavi
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales','**', '*.{rb,yml}').to_s]
    config.i18n.default_locale = :fr

    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.autoload_paths << Rails.root.join('lib')

    config.generators do |g|
      g.test_framework :rspec,
                       :fixtures => true,
                       :view_specs => false,
                       :helper_specs => false,
                       :routing_specs => false,
                       :controller_specs => true,
                       :request_specs => true
      g.fixture_replacement :factory_bot, :dir => "spec/factories"
    end

  end
end

ActiveSupport::Deprecation.behavior = [:stderr, :log]

require File.expand_path('config/extra_config.rb',Rails.root)

RABBITMQ_CONFIG=ExtraConfig.new(File.expand_path("config/rabbitmq.yml",Rails.root),"RABBITMQ")
