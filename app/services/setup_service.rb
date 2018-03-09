class SetupService

  class NilUser < StandardError; end
  class InternalRedirectDomain < StandardError; end
  class InvalidEmail < StandardError; end

  attr_reader :setup_subscription_service

  def initialize(user, options={})
    @user=user
    raise NilUser unless @user
    @setup_subscription_service = options[:setup_subscription_service]
  end

  def need_setup?
    @user.is_gadz && !(@user.email_source_accounts.any? && @user.email_redirect_accounts.any?)
  end

  def prepare
    EmailSourceAccount.create_standard_aliases_for(@user) unless @user.email_source_accounts.any?
  end

  def process_form(params)
    create_email_redirect_account(params[:redirect])
    create_google_apps if params[:google_apps] == "true"
    subscribe_to_default_mailing_lists if params[:default_mls] == "true"
  end

  def subscribe_to_default_mailing_lists?
    @user.is_gadz && (@user.gadz_proms_principale.to_i >= Time.now.year-3)
  end

  def email_redirect_account
    @email_redirect_account
  end

  private

  def create_email_redirect_account(email)
    @email_redirect_account = @user.email_redirect_accounts.new(
        redirect: email,
        type_redir: 'smtp',
        flag: 'inactive'
    )
    @email_redirect_account.generate_new_token
    raise InternalRedirectDomain if @email_redirect_account.is_internal_domains_address?
    raise InvalidEmail unless  @email_redirect_account.save
  end

  def create_google_apps
    @user.create_google_apps
  end

  def subscribe_to_default_mailing_lists
    return unless setup_subscription_service

    if subscribe_to_default_mailing_lists?
      setup_subscription_service.do_subscribe
    end
  end
end