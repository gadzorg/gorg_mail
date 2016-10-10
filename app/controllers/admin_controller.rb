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

      @external_emails = Ml::ExternalEmail.where("email LIKE '%#{search}%'")
      @esas = EmailSourceAccount.where("email LIKE '%#{search.split('@').first}%'")
      @eras = EmailRedirectAccount.where("redirect LIKE '%#{search}%'")
      @aliases = Alias.where("email LIKE '%#{search}%'") + Alias.where("redirect LIKE '%#{search}%'")
    end
  end
end
