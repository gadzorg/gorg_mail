class Ml::ExternalEmailsController < ApplicationController
  before_action :set_ml_external_email, only: [:show, :edit, :update, :destroy]

  # GET /ml/external_emails
  # GET /ml/external_emails.json
  def index
    @ml_external_emails = Ml::ExternalEmail.all
    authorize! :read, @ml_external_emails
  end

  # GET /ml/external_emails/1
  # GET /ml/external_emails/1.json
  def show
    authorize! :read, @ml_external_email
  end

  # GET /ml/external_emails/new
  def new
    @ml_external_email = Ml::ExternalEmail.new
    authorize! :create, @ml_external_email
  end

  # GET /ml/external_emails/1/edit
  def edit
    authorize! :update, @ml_external_email
  end

  # POST /ml/external_emails
  # POST /ml/external_emails.json
  def create
    @ml_external_email = Ml::ExternalEmail.new(ml_external_email_params)
    authorize! :create, @ml_external_email

    respond_to do |format|
      if @ml_external_email.save
        format.html { redirect_to @ml_external_email, notice: 'External email was successfully created.' }
        format.json { render :show, status: :created, location: @ml_external_email }
      else
        format.html { render :new }
        format.json { render json: @ml_external_email.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /ml/external_emails/1
  # PATCH/PUT /ml/external_emails/1.json
  def update
    authorize! :update, @ml_external_email
    respond_to do |format|
      if @ml_external_email.update(ml_external_email_params)
        format.html { redirect_to @ml_external_email, notice: 'External email was successfully updated.' }
        format.json { render :show, status: :ok, location: @ml_external_email }
      else
        format.html { render :edit }
        format.json { render json: @ml_external_email.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /ml/external_emails/1
  # DELETE /ml/external_emails/1.json
  def destroy
    authorize! :delete, @ml_external_email
    @ml_external_email.destroy
    respond_to do |format|
      format.html { redirect_to ml_external_emails_url, notice: 'External email was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ml_external_email
      @ml_external_email = Ml::ExternalEmail.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def ml_external_email_params
      params.require(:ml_external_email).permit(:list_id, :email)
    end
end
