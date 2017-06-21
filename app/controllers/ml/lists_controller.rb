class Ml::ListsController < ApplicationController
  before_action :set_ml_list, only: [:show, :edit, :update, :destroy, :set_role, :sync_with_google, :add_email, :remove_email]

  # GET /ml/lists
  # GET /ml/lists.json
  def index
    authorize! :read, Ml::List
    @ml_lists = Ml::List.accessible_by(current_ability).includes(redirection_aliases: :email_virtual_domain).search(params[:search])
    #authorize! :read, @ml_lists
  end

  # GET /ml/lists/1
  # GET /ml/lists/1.json
  def show
    authorize! :read, @ml_list
    @search = params[:search]
    @members = @ml_list.all_members.search(@search).order(:firstname).page(params[:page]).per_page(20)#.where(email_source_accounts: {primary: true})
    @external_emails = @ml_list.ml_external_emails
    @redirection_aliases = @ml_list.redirection_aliases
    @admins_and_moderators = @ml_list.super_members
    if can? :admin_members, @ml_list
      @pendings = @ml_list.pendings
      @banneds = @ml_list.banneds
    end

    @current_user_is_member = @ml_list.all_members.include?(@current_user)
  end

  # GET /ml/lists/new
  def new
    @ml_list = Ml::List.new
    authorize! :create, @ml_list
    @evd = EmailVirtualDomain.all.map(&:name)
  end

  # GET /ml/lists/1/edit
  def edit
    authorize! :update, @ml_list
    @evd = EmailVirtualDomain.all.map(&:name)
  end

  # POST /ml/lists
  # POST /ml/lists.json
  def create
    @ml_list = Ml::List.new(ml_list_params)
    authorize! :create, @ml_list

    respond_to do |format|
      if @ml_list.save
        format.html { redirect_to @ml_list, notice: 'List was successfully created.' }
        format.json { render :show, status: :created, location: @ml_list }
      else

        format.html { render :new }
        format.json { render json: @ml_list.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /ml/lists/1
  # PATCH/PUT /ml/lists/1.json
  def update
    authorize! :update, @ml_list
    respond_to do |format|
      if @ml_list.update(ml_list_params)
        format.html { redirect_to @ml_list, notice: 'List was successfully updated.' }
        format.json { render :show, status: :ok, location: @ml_list }
      else
        format.html { render :edit }
        format.json { render json: @ml_list.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /ml/lists/1
  # DELETE /ml/lists/1.json
  def destroy
    authorize! :delete, @ml_list
    @ml_list.destroy
    respond_to do |format|
      format.html { redirect_to ml_lists_url, notice: 'List was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def join
    @ml_list = Ml::List.find_by(id: params[:list_id])
    authorize! :suscribe, @ml_list
    @user = User.find(params[:user_id])
    authorize! :manage_suscribtion, @user
    service = MailingListSubscriptionService.new(list:@ml_list,user:@user)
    if service.do_subscribe
      get_list(@user)
      respond_to do |format|
        flash[:notice] = "Tu as rejoint la liste de diffusion #{@ml_list.name}"
        format.html{redirect_to ml_list_path(@ml_list, search: params[:search])}
        format.json { head :no_content }
        format.js
      end
    else
      get_list(@user)
      respond_to do |format|
        flash[:error] = "Impossible de rejoindre la liste de diffusion #{@ml_list.name}"
        format.html {redirect_to ml_list_path(@ml_list, search: params[:search])}
        format.json { head :no_content }
        format.js
      end
    end
  end

  def leave
    lists_user=Ml::ListsUser.find_by(user_id: params[:user_id],list_id: params[:list_id])
    authorize! :destroy, lists_user

    if lists_user
      @ml_list = lists_user.list
      @user = lists_user.user

      if @ml_list.remove_user(@user)
        respond_to do |format|
          flash[:notice] = "Tu as quitté la liste de diffusion #{@ml_list.name}"
          format.html{redirect_to ml_list_path(@ml_list, search: params[:search])}
          format.json { head :no_content }
          format.js do
            get_list(@user)
            render :join
          end
        end

      else
        get_list(@user)
        respond_to do |format|
          flash[:error] = "Impossible de quitter la liste de diffusion #{@ml_list.name}"
          format.html{redirect_to ml_list_path(@ml_list, search: params[:search])}
          format.json { head :no_content }
          format.js do
            get_list(@user)
            render :join
          end
        end
      end
    else
      get_list(@user)
      respond_to do |format|
        flash[:notice] = "Cet utilisateur n'appartient pas à la liste #{@ml_list.name}"
        format.html{redirect_to ml_list_path(@ml_list, search: params[:search])}
        format.json { head :no_content }
        format.js do
          get_list(@user)
          render :join
        end
      end
    end
  end

  def add_email
    authorize! :admin_members, @ml_list
    if @ml_list.add_email(params[:email])
      redirect_to @ml_list, :flash => { :notice => "L'adresse #{params[:email]} a bien été ajoutée à la liste" }
    else
      redirect_to @ml_list, :flash => { :error => "Impossible d'ajouter cette adresse" }
    end
  end

  def remove_email
    authorize! :admin_members, @ml_list
    email_external = Ml::ExternalEmail.find(params[:email_id])
    if @ml_list.remove_email(email_external)
      redirect_to @ml_list
    else
      redirect_to @ml_list, :flash => { :error => "Impossible de supprimer cette adresse" }
    end
  end

  def set_role
    authorize! :admin_members, @ml_list
    role = params[:role]
    search = params[:search]
    user = User.find(params[:user_id])
    if @ml_list.set_role(user, role)
      redirect_to ml_list_path(@ml_list, search: search)
    else
      redirect_to ml_list_path(@ml_list, search: search), :flash => { :error => "Impossible d'attribuer le rôle #{role}" }
    end

  end

  def sync_with_google
    authorize! :manage, @ml_list
    flash=MailingListsService.new(@ml_list).update ? {notice: "Ordre envoyé"} : {error: "Impossible de se connecter au serveur de messagerie"}
    redirect_to ml_list_path(@ml_list), :flash =>flash
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ml_list
      @ml_list = Ml::List.find_by(id: params[:id]) || Ml::List.find_by(id: params[:list_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def ml_list_params
      params.require(:ml_list).permit(:name, :email, :description, :aliases, :diffusion_policy, :inscription_policy, :is_public, :messsage_header, :message_footer, :is_archived, :custom_reply_to, :default_message_deny_notification_text, :msg_welcome, :msg_goodbye, :is_archived, :message_max_bytes_size, :group_uuid)
    end
end
