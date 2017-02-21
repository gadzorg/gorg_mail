class Admin::MasqueradesController < Devise::MasqueradesController
  def show
    authorize!(:masquerade, User)

    super
  end
end