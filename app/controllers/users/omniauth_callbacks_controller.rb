include ActionView::Helpers::TextHelper
class Users::OmniauthCallbacksController < ApplicationController

  def GadzOrg

    @data=request.env['omniauth.auth']

    # @data={"provider"=>"GadzOrg",
    #       "uid"=>"thomas.fuzeau.2008",
    #       "info"=>{"email"=>"thomas.fuzeau@gadz.org"},
    #       "credentials"=>{"ticket"=>"ST-364828-uc7TFKGJDcIOY0upGxE0-cas"},
    #       "extra"=>
    #       {"user"=>"thomas.fuzeau.2008",
    #       "last_change"=>"2012-08-29",
    #       "sex"=>"male",
    #       "centre"=>"CER de Metz",
    #       "promo"=>"X2008",
    #       "lastname"=>"Fuzeau",
    #       "firstname"=>"Thomas",
    #       "directory_name"=>"Fuzeau Thomas",
    #       "type"=>"gadz",
    #       "ddp"=>"zgo,www",
    #       "display_name"=>"Thomas",
    #       "ensamid"=>"20081398",
    #       "username"=>"thomas.fuzeau.2008",
    #       "is_admin"=>"false",
    #       "allproms"=>"81-21.me208",
    #       "registration_date"=>"2012-08-06 22:15:16.0",
    #       "pgtype"=>"pg",
    #       "soce_id"=>"66273",
    #       "full_name"=>"Thomas Fuzeau"}}
    data = request.env['omniauth.auth']

        @user = User.omniauth(data)

    if @user.persisted?
        flash[:notice] = I18n.t "devise.omniauth_callbacks.success"
        sign_in_and_redirect @user, :event => :authentication
    else
        flash[:alert] = I18n.t 'omniauth.error'
        redirect_to new_user_registration_url
    end

end

end