class AdminController < ApplicationController
  def index
    authorize! :read, :admin
  end
end
