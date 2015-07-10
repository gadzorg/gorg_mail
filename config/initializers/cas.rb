Devise.setup do |config|

  # ==> OmniAuth
  # Add a new OmniAuth provider. Check the wiki for more information on setting
  # up on your models and hooks.
  # config.omniauth :github, 'APP_ID', 'APP_SECRET', :scope => 'user,public_repo'

  config.omniauth :developer unless Rails.env.production?

  require "omniauth-cas"

  config.omniauth :cas, name: "GadzOrg",
                  host:      'auth-dev.gadz.org:443',
                  login_url: '/cas/login',
                  logout_url: '/cas/logout',
                  service_validate_url: '/cas/serviceValidate',
                  saml_validate_url: '/cas/samlValidate',
                  saml_time_url: '/cas',
                  saml: true,
                  ssl: true,
                  disable_ssl_verification: true,
                  return_url: false,
                  renew: true

end