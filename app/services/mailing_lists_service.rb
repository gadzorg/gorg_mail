require 'gorg_message_sender'

class MailingListsService

  def initialize(mailing_list, options = {})
    @mailing_list = mailing_list
    @message_sender=options[:message_sender] || GorgService::Producer.new
  end

  def update
    request_mailing_list_update unless self.class.no_sync?
  end

  def delete
    request_mailing_list_delete unless self.class.no_sync?
  end

  def footer
"#{@mailing_list.message_footer}

-----
Vous recevez ce message car vous être membre de la liste de diffusion '#{@mailing_list.name}'
Pour vous désinscrire, consultez #{Rails.application.routes.url_helpers.unsubscribe_url(host: 'https://emails.gadz.org')}
"
  end

  def request_mailing_list_update
    msg = {
      name: @mailing_list.name,
      primary_email: @mailing_list.email,
      description: @mailing_list.description,
      aliases: @mailing_list.aliases ? @mailing_list.aliases.split : [],
      owners: @mailing_list.admins.primary_emails,
      managers: @mailing_list.moderators.primary_emails,
      members: @mailing_list.all_emails,
      message_max_bytes_size: @mailing_list.message_max_bytes_size ,
      object_tag:  @mailing_list.messsage_header,
      message_footer: footer,
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


  def self.no_sync_block
    begin
      @no_sync=true
      yield
    ensure
      @no_sync=false
    end
  end

  private
    def send_message(data, routing_key)
      unless RABBITMQ_CONFIG["no_sync"]
        begin
          message=GorgService::Message.new(event: routing_key,
                                           data: data,
                                           reply_to: GorgService.environment.reply_exchange.name)
          @message_sender.publish_message(message)
          return true
        rescue Bunny::TCPConnectionFailedForAllHosts
          Rails.logger.error "Unable to connect to RabbitMQ server"
          return false
        end
      else
        Rails.logger.error "RabbitMQ sync disabled"
        return true
      end
    end

    def self.no_sync?
      @no_sync
    end
  end