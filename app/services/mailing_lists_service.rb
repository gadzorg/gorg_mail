require 'gorg_message_sender'

class MailingListsService

  def initialize(mailing_list, options = {})
    @mailing_list = mailing_list
    @message_sender=options[:message_sender] || GorgMessageSender.new
  end

  def update
    request_mailing_list_update
  end

  def delete
    request_mailing_list_delete
  end

  def request_mailing_list_update
    msg = {
      name: @mailing_list.name,
      primary_email: @mailing_list.email,
      description: @mailing_list.description,
      aliases: @mailing_list.aliases.split,
      members: @mailing_list.all_emails,
      message_max_bytes_size: @mailing_list.message_max_bytes_size ,
      object_tag:  @mailing_list.messsage_header,
      message_footer: @mailing_list.message_footer ,
      is_archived: @mailing_list.is_archived,
      distribution_policy: @mailing_list.diffusion_policy
    }
    send_message(msg, 'request.mailinglist.update')
  end

  def request_mailing_list_delete
    msg = {
        mailling_list_key: @mailing_list.email,
    }
    send_message(msg, 'request.mailinglist.delete')
  end

  private
    def send_message(msg, routing_key)
      begin
        @message_sender.send_message(msg, routing_key)
        return true
      rescue Bunny::TCPConnectionFailedForAllHosts
        Rails.logger.error "Unable to connect to RabbitMQ server"
        return false
      end
    end
  end