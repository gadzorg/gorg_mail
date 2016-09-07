require 'gorg_message_sender'

class GoogleApps
  DEFAULT_DOMAIN=Configurable[:main_mail_domain]
  DEFAULT_GOOGLE_APPS_DOMAIN=Configurable[:default_google_apps_domain]

  def initialize(user, options = {})
    @user=user
    @domain=options[:domain] || DEFAULT_GOOGLE_APPS_DOMAIN
    @message_sender=options[:message_sender] || GorgMessageSender.new
    @email_aliases = @user.email_source_accounts.map(&:to_s)

    # find the first @gadz.org adresse of the users and use it's base
    evd_id = EmailVirtualDomain.find_by(name: DEFAULT_DOMAIN).id
    begin
      email_base = @user.primary_email.email
      @google_apps_email = email_base + "@#{@domain}"
    rescue
      puts 'Any Email_source_account with gadz.org for this user :-( Create it before googleapps generation'
      return false
    end
  end

  def generate
    request_google_apps_creation
    create_google_apps_redirection

  end

  def update
    request_google_apps_update
  end

  def create_google_apps_redirection
    # if @user.email_source_account
    unless @user.has_google_apps
    @user.email_redirect_accounts.create(
        redirect: @google_apps_email,
        type_redir: 'googleapps',
        flag: 'active',
        confirmed: true
    )
    end

  end

  def request_google_apps_creation
    msg = {
        google_apps_account: {
            gram_account_uuid: @user.uuid,
            primary_email: @google_apps_email,
            aliases:  @email_aliases
        }
    }
    send_message(msg, 'request.googleapps.user.create')
  end

  def request_google_apps_update
    msg = {
        google_apps_account: {
            gram_account_uuid: @user.uuid,
            aliases:  @email_aliases
        }
    }
    send_message(msg, 'request.googleapps.user.update')
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