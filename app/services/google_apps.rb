require 'gorg_message_sender'

class GoogleApps
  DEFAULT_DOMAIN=Configurable[:main_mail_domain]
  DEFAULT_GAPPS_DOMAIN_ALIAS=Configurable[:default_google_apps_domain_alias]

  def initialize(user, options = {})
    @user=user
    @domain=options[:domain] || DEFAULT_DOMAIN
    @domain_alias=options[:domain_alias] || DEFAULT_GAPPS_DOMAIN_ALIAS
    @message_sender=options[:message_sender] || GorgMessageSender.new
    @email_aliases = @user.email_source_accounts.map(&:to_s)

    begin
      email_base = @user.primary_email.email
      @google_apps_email = email_base + "@#{@domain}"
      @google_apps_email_alias = email_base + "@#{@domain_alias}"
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
        redirect: @google_apps_email_alias,
        type_redir: 'googleapps',
        flag: 'active',
        confirmed: true
    )
    end

  end

  def request_google_apps_creation
    msg = {
      gram_account_uuid: @user.uuid,
      primary_email: @google_apps_email,
      aliases:  @email_aliases
    }
    send_message(msg, 'request.googleapps.user.create')
  end

  def request_google_apps_update
    msg = {
      gram_account_uuid: @user.uuid,
      aliases:  @email_aliases
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