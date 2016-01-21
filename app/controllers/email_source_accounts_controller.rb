class EmailSourceAccountsController < ApplicationController
  before_action :set_email_source_account, only: [:show, :edit, :update, :destroy]
  before_action :set_user


  # GET /users/:user_id/email_source_accounts.json
  def index
    @email_source_accounts = @user.email_source_accounts.all
    @email_source_accounts.each{|esa| authorize!(:show, esa)}
  end


  # GET /users/:user_id/email_source_accounts/1.json
  def show
    authorize! :show, @email_source_account
  end


  # POST /users/:user_id/email_source_accounts.json
  def create
    @email_source_account = @user.email_source_accounts.new(email_source_account_params)
    authorize! :create, @email_source_account

    respond_to do |format|
      if @email_source_account.save
        format.js do
          @emails_source = @user.email_source_accounts.map { |e| e } # sans le map, il retourne des ESA avec un id vide. à vérifier TODO
        end
        format.json { render :show, status: :created, location: @email_source_account, format: :json }
      else
        format.json { render json: @email_source_account.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/:user_id/email_source_accounts/1.json
  def update
    authorize! :update, @email_source_account
    respond_to do |format|
      if @email_source_account.update(email_source_account_params)
        format.json { render :show, status: :ok, location: @email_source_account }
      else
        format.json { render json: @email_source_account.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /email_source_accounts/1.json
  def destroy
    authorize! :destroy, @email_source_account
    @email_source_account.destroy

    @emails_source = @user.email_source_accounts.map { |e| e } # sans le map, il retourne des ESA avec un id vide. à vérifier TODO

    respond_to do |format|
      format.js
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_email_source_account
    @email_source_account = EmailSourceAccount.find(params[:id])
  end

  def set_user
    @user = User.find(params[:user_id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def email_source_account_params
    params.require(:email_source_account).permit(:email, :email_virtual_domain, :email_virtual_domain_id, :type_source, :user_id)
  end
end
