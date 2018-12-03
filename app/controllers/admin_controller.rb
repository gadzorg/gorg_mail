class AdminController < ApplicationController
  def index
    authorize! :read, :admin
  end

  def search_email
    authorize! :read, :admin
    search = params[:search] || nil

    if search.blank?
      @external_emails, @eras, @esas, @aliases = [[]]*4
    else

      @external_emails = Ml::ExternalEmail.includes(:ml_list).where("email LIKE ?",search)
      @esas = EmailSourceAccount.includes(:email_virtual_domain, :user).where("email LIKE ?",search.split('@').first)
      @eras = EmailRedirectAccount.includes( :user).where("redirect LIKE ?",search)
      @aliases = Alias.includes(:email_virtual_domain).where("email LIKE ?",search) + Alias.includes(:email_virtual_domain).where("redirect LIKE ?",search)
    end
  end
end
