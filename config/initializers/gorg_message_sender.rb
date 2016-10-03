# Use config from file unless ENV VAR are present
GorgMessageSender.configure do |c|

  # Id used to set the event_sender_id
  c.application_id = RABBITMQ_CONFIG["sender"]

  # RabbitMQ network and authentification
  #c.host = "localhost" 
  c.host = RABBITMQ_CONFIG["host"]
  #c.port = 5672 
  c.port = RABBITMQ_CONFIG["port"]
  #c.vhost = "/"
  c.vhost = RABBITMQ_CONFIG["vhost"]
  #c.user = nil
  c.user = RABBITMQ_CONFIG["user"]
  #c.password = nil
  c.password = RABBITMQ_CONFIG["password"]

  # Exchange configuration
  #c.exchange_name ="exchange"
  c.exchange_name = RABBITMQ_CONFIG["exchange_name"]

  #c.durable_exchange= true
end