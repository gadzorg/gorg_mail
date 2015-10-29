class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy, :dashboard, :create_google_apps, :flag  ]
  autocomplete :user, :hruid , :full => true, :display_value =>:hruid, extra_data: [:id, :firstname ] #, :scopes => [:search_by_name]


  # GET /users
  # GET /users.json
  def index
    @users = User.accessible_by(current_ability)
    authorize! :read, User
  end

  # GET /users/1
  # GET /users/1.json
  def show
    authorize! :read, @user
  end

  # GET /users/new
  def new
    @user = User.new
    authorize! :create, @user
    @roles=Role.accessible_by(current_ability)
  end

  # GET /users/1/edit
  def edit
    authorize! :update, @user
    @roles=Role.accessible_by(current_ability)
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)
    authorize! :create, @user
    authorize! :update, Role.find(user_params[:role_id])

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    authorize! :update, @user
    authorize! :update, Role.find(user_params[:role_id])

    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    authorize! :destroy, @user
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end


  def search_by_id
    redirect_to user_path(params[:id])
  end

  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user =(params[:id] ?  User.find(params[:id]) : current_user)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:email, :firstname, :lastname, :hruid, :id, :role_id)
    end
end
