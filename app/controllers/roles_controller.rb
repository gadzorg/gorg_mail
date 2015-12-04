class RolesController < ApplicationController

  before_action :set_role, only: [:create,:destroy]
  before_action :set_user, only: [:create,:destroy]

  # GET /roles
  # GET /roles.json
  def index
    @roles = Role.all
    authorize! :read, Role
  end

  # POST /users/1/roles
  # POST /users/1/roles.json
  def create
    authorize! :create, @role

    respond_to do |format|
      if params[:role][:name].present? && @user.add_role(params[:role][:name])
        format.html { redirect_to user_path(@user), notice: I18n.translate('roles.flash.create.success', role: params[:role][:name], user: @user.fullname) }
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
    authorize! :destroy, @role

    @user.remove_role params[:id]

    respond_to do |format|
      format.html { redirect_to roles_path, notice: I18n.translate('roles.flash.destroy.success', role: params[:id], user: @user.fullname) }
      format.json { head :no_content }
    end

  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end

  def set_role
    @role = Role.find_by_name(params[:id])
  end


  # Never trust parameters from the scary internet, only allow the white list through.
  def role_params
    params.require(:role).permit(:name)
  end
end
