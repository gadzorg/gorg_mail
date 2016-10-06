class StaticPagesController < ApplicationController
  def index
  end

  def landing
    if current_user.nil?
      @maintenance_mode = check_maintenance_mode
      @maintenance_message = Configurable[:maintenance_message] if @maintenance_mode
      render layout: "landing"
    else
      redirect_to dashboard_path
    end
  end
end
