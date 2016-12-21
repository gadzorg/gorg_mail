class Api::SearchController < ApplicationController

  http_basic_authenticate_with name: Rails.application.secrets.api_user, password: Rails.application.secrets.api_password

  def search
    esa=EmailSourceAccount.find_by_full_email(params[:query])
    if esa && esa.user
      render json: {uuid: esa.user.uuid}, status: 200
    else
      render json: {error:{status: 404, message: "Email not found"}}, status: :not_found
    end
  end

end