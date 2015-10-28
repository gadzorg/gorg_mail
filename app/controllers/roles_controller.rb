class RolesController < ApplicationController
  before_action :set_user, only: [:new,:create,:destroy]

  # GET /roles
  # GET /roles.json
  def index_all
    @roles = Role.accessible_by(current_ability)
    authorize! :read, Role
  end




  # GET /users/1/roles/new
  def new
    authorize! :create, Role
    @roles=Role.base_roles.select{|r| !@user.has_role? r}
  end


  # POST /users/1/roles
  # POST /users/1/roles.json
  def create
    authorize! :create, Role

    respond_to do |format|
      if params[:role][:name].present? && @user.add_role(params[:role][:name])
        format.html { redirect_to user_path(@user), notice: 'Role was successfully created.' }
        format.json { redirect_to user_path(@user, format: :json), status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @role.errors, status: :unprocessable_entity }
      end
    end
  end


  # DELETE /users/1/roles/support
  # DELETE /users/1/roles/support.json
  def destroy
    authorize! :destroy, Role

    @user.remove_role params[:id]

    respond_to do |format|
      format.html { redirect_to user_roles_path(@user), notice: 'Alias was successfully destroyed.' }
      format.json { head :no_content }
    end

  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def role_params
    params.require(:role).permit(:name)
  end
end
