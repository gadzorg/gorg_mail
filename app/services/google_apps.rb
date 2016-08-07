require 'gorg_message_sender'

class GoogleApps
  DEFAULT_DOMAIN=Configurable[:main_mail_domain]
  DEFAULT_GOOGLE_APPS_DOMAIN=Configurable[:default_google_apps_domain]

  def initialize(user, options = {})
    @user=user
    @domain=options[:domain] || DEFAULT_GOOGLE_APPS_DOMAIN
    @message_sender=options[:message_sender] || GorgMessageSender.new

    # find the first @gadz.org adresse of the users and use it's base
    evd_id = EmailVirtualDomain.find_by(name: DEFAULT_DOMAIN).id
    email_base = @user.email_source_accounts.find_by(evd_id).email
    @google_apps_email = email_base + "@#{@domain}"
  end

  def generate
    request_google_apps_creation
    create_google_apps_redirection

  end

  def create_google_apps_redirection
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
    msg={google_apps_account: {email: @google_apps_email}}
    send_message(msg, 'request.google_app.create')
  end

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