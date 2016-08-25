#Load Config file
CONFIG_RABBITMQ ||= YAML::load(File.open(File.expand_path("config/rabbitmq.yml")))[Rails.env]

# Use config from file unless ENV VAR are present
GorgMessageSender.configure do |c|

  # Id used to set the event_sender_id
  c.application_id = ENV["RABBITMQ_SENDER_ID"]|| CONFIG_RABBITMQ["sender"]

  # RabbitMQ network and authentification
  #c.host = "localhost" 
  c.host = ENV["RABBITMQ_HOST"]|| CONFIG_RABBITMQ["host"]
  #c.port = 5672 
  c.port = ENV["RABBITMQ_PORT"]|| CONFIG_RABBITMQ["port"]
  #c.vhost = "/"
  c.vhost = ENV["RABBITMQ_VHOST"]|| CONFIG_RABBITMQ["vhost"]
  #c.user = nil
  c.user = ENV["RABBITMQ_USER"]|| CONFIG_RABBITMQ["user"]
  #c.password = nil
  c.password = ENV["RABBITMQ_PASSWORD"]|| CONFIG_RABBITMQ["password"]

  # Exchange configuration
  #c.exchange_name ="exchange"
  c.exchange_name = ENV["RABBITMQ_EXCHANGE"]|| CONFIG_RABBITMQ["exchange_name"]

  #c.durable_exchange= true
end