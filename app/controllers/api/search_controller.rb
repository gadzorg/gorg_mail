class Api::SearchController < ApplicationController

  def search
    esa=EmailSourceAccount.find_by_full_email(params[:query])
    if esa && esa.user
      render json: {uuid: esa.user.uuid}, status: 200
    else
      render json: {error:{status: 404, message: "Email not found"}}, status: :not_found
    end
  end

end