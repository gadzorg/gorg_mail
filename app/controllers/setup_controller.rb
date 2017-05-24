class SetupController < ApplicationController

  before_action :set_user_and_authorize
  before_action :set_service
  before_action :check_setup_need, only: [:index, :setup]

  layout 'no-menu'

  def index
    @service.prepare
    @primary_email = @user.primary_email.to_s
  end

  def setup
    respond_to do |format|
      begin
        @service.process_form(setup_params)

        #attention, la ligne suivante est également dans le controleur user / dashboard
        EmailValidationMailer.confirm_email(@user,@service.email_redirect_account,confirm_user_email_redirect_accounts_url(@user, @service.email_redirect_account.confirmation_token)).deliver_now

        format.html { redirect_to setup_finish_path }
      rescue SetupService::InternalRedirectDomain
        format.html { redirect_to setup_path, notice: "Tu dois renseigner une adresse qui n'est pas gérée par Gadz.org" }
      rescue SetupService::InvalidEmail
        format.html { return redirect_to setup_path, notice: "L'adresse email que tu as entré n'est pas valide car il #{@service.email_redirect_account.errors.messages[:redirect].join(", ")}"}
      end
    end

  end

  def finish
  end

private
  def set_user_and_authorize
    @user=current_user
    authorize! :setup, @user
  end

  def set_service
    @service=SetupService.new(@user)
  end

  def setup_params
    params.permit(:google_apps, :redirect)
  end

  def check_setup_need
    redirect_to root_path unless @service.need_setup?
  end

end
