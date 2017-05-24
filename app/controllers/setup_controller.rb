class SetupController < ApplicationController

  before_action :set_user
  before_action :check_setup_need, only: [:setup_email_source_accounts, :index, :setup]

  def setup_email_source_accounts
    @user= current_user
    authorize! :setup, @user
    presence_of_email_source = @user.email_source_accounts.any?
    presence_of_email_redirection = @user.email_redirect_accounts.any?
    if presence_of_email_source && presence_of_email_redirection
      return redirect_to dashboard_path
    else
      EmailSourceAccount.create_standard_aliases_for(@user) unless presence_of_email_source
      return redirect_to setup_path
    end

    # @esas=EmailSourceAccountGenerator.new(@user).generate
    # @esas=EmailSourceAccountGenerator.new(@user, domain: "m4.am").generate

  end

  def index
    @user= current_user
    authorize! :setup, @user

    @primary_email = @user.primary_email.to_s
    render layout: "no-menu"

  end

  def setup
    @user= current_user
    authorize! :setup, @user

    @user=current_user

    @email_redirect_account = @user.email_redirect_accounts.new(redirect: params[:redirect])

    respond_to do |format|
      if @email_redirect_account.is_internal_domains_address?
        format.html { redirect_to setup_path, notice: "Tu dois renseigner une adresse qui n'est pas gérée par Gadz.org" }
      else
        authorize! :create, @email_redirect_account
        @email_redirect_account.type_redir = "smtp"
        @email_redirect_account.flag = "inactive"

        @email_redirect_account.generate_new_token

        if @email_redirect_account.save

          #attention, les deux lignes suivantes sont égaleement dans le controleur user / dashboard
          @emails_redirect = @user.email_redirect_accounts.order(:type_redir).select(&:persisted?)
          EmailValidationMailer.confirm_email(@user,@email_redirect_account,confirm_user_email_redirect_accounts_url(@user, @email_redirect_account.confirmation_token)).deliver_now
        else
          format.html { return redirect_to setup_path, notice: "L'adresse email que tu as entré n'est pas valide"}
        end
        if params[:google_apps] == "true"
          @user.create_google_apps
        end

        format.html { redirect_to setup_finish_path }

      end
    end




  end

  def finish
    @user=current_user
    authorize! :setup, @user
    render layout: "no-menu"

  end

private
  def set_user
    @user=current_user
  end

  def setup_params
    params.permit(:google_apps, :redirect)
  end

  def check_setup_need
    redirect_to root_path unless SetupService.new(@user).need_setup?
  end

end
