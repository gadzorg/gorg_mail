class Admin::MasqueradesController < Devise::MasqueradesController
  def show
    authorize!(:masquerade, User)
    @user=User.find_by(id: params[:id])
    @user&&@user.update_from_gram
    super
  end
end