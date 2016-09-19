#!/usr/bin/env ruby
# encoding: utf-8

require 'gorg_service'

# For default values see : https://github.com/Zooip/gorg_service
GorgService.configure do |c|
  # application name for display usage
  c.application_name= "API GrAM v2"
  # application id used to find message from this producer
  c.application_id=RABBITMQ_CONFIG["sender"]

  ## RabbitMQ configuration
  # 
  ### Authentification
  # If your RabbitMQ server is password protected put it here
  #
  c.rabbitmq_user=RABBITMQ_CONFIG["user"]
  c.rabbitmq_password=RABBITMQ_CONFIG["password"]
  #  
  ### Network configuration :
  #
  c.rabbitmq_host=RABBITMQ_CONFIG["host"]
  c.rabbitmq_port=RABBITMQ_CONFIG["port"]
  c.rabbitmq_vhost=RABBITMQ_CONFIG["vhost"]

  c.rabbitmq_exchange_name=RABBITMQ_CONFIG["exchange_name"]
  #
  # time before trying again on softfail in milliseconds (temporary error)
  c.rabbitmq_deferred_time=RABBITMQ_CONFIG["deferred_time"]
  # 
  # maximum number of try before discard a message
  c.rabbitmq_max_attempts=RABBITMQ_CONFIG["max_attempts"]
  #
  # The routing key used when sending a message to the central log system (Hardfail or Warning)
  # Central logging is disable if nil
  c.log_routing_key=RABBITMQ_CONFIG["logging_key"]
  #
  # Routing hash
  #  map routing_key of received message with MessageHandler 
  #  exemple:
  # c.message_handler_map={
  #   "some.routing.key" => MyMessageHandler,
  #   "Another.routing.key" => OtherMessageHandler,
  #   "third.routing.key" => MyMessageHandler,
  # }

  c.logger=Rails.logger

  c.message_handler_map={
    "notify.googleapps.user.created"=> GoogleAppsCreatedMessageHandler
  }
end