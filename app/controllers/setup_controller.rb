class SetupController < ApplicationController

  def index
    @user= current_user
    authorize! :setup, @user

    return redirect_to dashboard_path if @user.email_source_accounts.any? && @user.email_redirect_accounts.any?

    @esas=EmailSourceAccountGenerator.new(@user).generate
  end

  def setup
    #TODO: vérifier qu'il ne s'agit pas d'une adresse Gadz.org
    @user=current_user
    
    @email_redirect_account = @user.email_redirect_accounts.new(redirect: params[:redirect])
    authorize! :create, @email_redirect_account
    @email_redirect_account.type_redir = "smtp"
    @email_redirect_account.flag = "inactive"
    
    @email_redirect_account.generate_new_token

    if @email_redirect_account.save
        
        #attention, les deux lignes suivantes sont égaleement dans le controleur user / dashboard
        @emails_redirect = @user.email_redirect_accounts.order(:type_redir).select(&:persisted?)
        EmailValidationMailer.confirm_email(@user,@email_redirect_account,confirm_user_email_redirect_accounts_url(@user, @email_redirect_account.confirmation_token)).deliver_now
    end

    #TODO: création de GoogleApps
    redirect_to finish_path
  end

  def finish
    @user=current_user
    authorize! :setup, @user
  end

private
  def setup_params
    params.permit(:google_apps, :redirect)
  end

end
