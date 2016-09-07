class StaticPagesController < ApplicationController
  def index
  end

  def landing
    if current_user.nil?
      render layout: "landing"
    else
      redirect_to dashboard_path
    end
  end
end
