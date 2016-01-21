class EmailVirtualDomainsController < ApplicationController
  before_action :set_email_virtual_domain, only: [:show, :edit, :update, :destroy]

  # GET /email_virtual_domains
  # GET /email_virtual_domains.json
  def index
    @email_virtual_domains = EmailVirtualDomain.accessible_by(current_ability)
    authorize! :read, EmailVirtualDomain
  end

  # GET /email_virtual_domains/new
  def new
    @email_virtual_domain = EmailVirtualDomain.new
    authorize! :create, @email_virtual_domain
  end

  # GET /email_virtual_domains/1/edit
  def edit
    authorize! :update, @email_virtual_domain
  end

  # POST /email_virtual_domains
  # POST /email_virtual_domains.json
  def create
    @email_virtual_domain = EmailVirtualDomain.new(email_virtual_domain_params)
    authorize! :create, @email_virtual_domain

    respond_to do |format|
      if @email_virtual_domain.save
        format.html { redirect_to @email_virtual_domain, notice: 'Email virtual domain was successfully created.' }
        format.json { render :show, status: :created, location: @email_virtual_domain }
      else
        format.html { render :new }
        format.json { render json: @email_virtual_domain.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /email_virtual_domains/1
  # PATCH/PUT /email_virtual_domains/1.json
  def update
    authorize! :update, @email_virtual_domain
    respond_to do |format|
      if @email_virtual_domain.update(email_virtual_domain_params)
        format.html { redirect_to @email_virtual_domain, notice: 'Email virtual domain was successfully updated.' }
        format.json { render :show, status: :ok, location: @email_virtual_domain }
      else
        format.html { render :edit }
        format.json { render json: @email_virtual_domain.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /email_virtual_domains/1
  # DELETE /email_virtual_domains/1.json
  def destroy
    authorize! :destroy, @email_virtual_domain
    @email_virtual_domain.destroy
    respond_to do |format|
      format.html { redirect_to email_virtual_domains_url, notice: 'Email virtual domain was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_email_virtual_domain
      @email_virtual_domain = EmailVirtualDomain.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def email_virtual_domain_params
      params.require(:email_virtual_domain).permit(:name, :aliasing)
    end
end
