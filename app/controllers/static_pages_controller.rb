class StaticPagesController < ApplicationController
  def index
  end

  def landing
    if current_user.nil?
      @maintenance_mode = check_maintenance_mode
      @maintenance_message = Configurable[:maintenance_message] if @maintenance_mode
      render layout: "landing"
    else
      if current_user.is_gadz_cached?
        redirect_to dashboard_path
      else
        redirect_to mailinglists_path
      end
    end
  end
end
