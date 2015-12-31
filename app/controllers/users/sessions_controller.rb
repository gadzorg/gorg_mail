class Users::SessionsController < Devise::SessionsController
  def new
    if Configurable[:legacy_auth_enabled]
      super
    else
      redirect_to omniauth_authorize_path(:user,:GadzOrg)
    end
  end

  # def create
  #   super
  # end
end
