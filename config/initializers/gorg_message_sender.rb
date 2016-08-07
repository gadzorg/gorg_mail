#Load Config file
CONFIG ||= YAML::load(File.open(File.expand_path("config/rabbitmq.yml")))[Rails.env]

# Use config from file unless ENV VAR are present
GorgMessageSender.configure do |c|

  # Id used to set the event_sender_id
  c.application_id = ENV["RABBITMQ_SENDER_ID"]|| CONFIG["rabbitmq"]["sender"]

  # RabbitMQ network and authentification
  #c.host = "localhost" 
  c.host = ENV["RABBITMQ_HOST"]|| CONFIG["rabbitmq"]["host"]
  #c.port = 5672 
  c.port = ENV["RABBITMQ_PORT"]|| CONFIG["rabbitmq"]["port"]
  #c.vhost = "/"
  c.vhost = ENV["RABBITMQ_VHOST"]|| CONFIG["rabbitmq"]["vhost"]
  #c.user = nil
  c.user = ENV["RABBITMQ_USER"]|| CONFIG["rabbitmq"]["user"]
  #c.password = nil
  c.password = ENV["RABBITMQ_PASSWORD"]|| CONFIG["rabbitmq"]["password"]

  # Exchange configuration
  #c.exchange_name ="exchange"
  c.exchange_name = ENV["RABBITMQ_EXCHANGE"]|| CONFIG["rabbitmq"]["exchange_name"]

  #c.durable_exchange= true
end