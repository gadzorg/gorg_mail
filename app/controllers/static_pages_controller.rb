class StaticPagesController < ApplicationController
  def index
  end

  def landing
    render layout: "landing"
  end
end
