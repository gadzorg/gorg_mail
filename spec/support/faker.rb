RSpec.configure do |config|
  config.before(:suite) do
    Faker::Config.locale = "fr"
  end
end
