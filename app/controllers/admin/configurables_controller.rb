class Admin::ConfigurablesController < ApplicationController
  # include the engine controller actions
  include ConfigurableEngine::ConfigurablesController

  # add your own filter(s) / layout
  before_filter :protect_my_code
   def protect_my_code
 	authorize! :read_admin, User
 end
end