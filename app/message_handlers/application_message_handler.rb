#!/usr/bin/env ruby
# encoding: utf-8


##Abstract class for payload validation and handling connectivity process
# Children classes should implement :
#  - process() : process the message stored in msg
#  - validate_payload() : method used to validate message's payload format
#                         Returns a boolean (true = valid, false = invalid)
#                         If not implemented, returns true
class ApplicationMessageHandler < GorgService::MessageHandler
  def initialize incoming_msg
    @msg=incoming_msg

    begin
      begin
        # validate_payload method should be implemented by children classes
        validate_payload

        # process method must be implemented by children classes
        process
      end




    rescue GorgService::HardfailError, GorgService::SoftfailError
      raise
    
    rescue StandardError => e
      Rails.logger.error "Uncatched exception : #{e.inspect}"
      raise_hardfail("Uncatched exception", error: e)
    end
  end

  #convenience method
  def msg
    @msg
  end

  ## Children implemented methods

  # process MUST be implemented
  # If not, raise hardfail
  def process
    Rails.logger.error("#{self.class} doesn't implement process()")
    raise_hardfail("#{self.class} doesn't implement process()", error: UnimplementedMessageHandlerError)
  end

  # validate_payload MAY be implemented
  # If not, assumes messages is valid, log a warning and returns true
  def validate_payload
    Rails.logger.warn("#{self.class} doesn't validate_payload(), assume payload is valid")
    true
  end
end


class InvalidPayloadError < StandardError; end
class UnimplementedMessageHandlerError < StandardError; end