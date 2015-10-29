class RolesController < ApplicationController

  # GET /roles
  # GET /roles.json
  def index
    @roles = Role.all
    authorize! :read, Role
  end






  private


  # Never trust parameters from the scary internet, only allow the white list through.
  def role_params
    params.require(:role).permit(:name)
  end
end
