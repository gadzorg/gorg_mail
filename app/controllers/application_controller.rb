class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  include ConfigurableEngine::ConfigurablesController

  after_filter :prepare_unobtrusive_flash
  private

  def after_sign_out_path_for(resource_or_scope)
    root_path
  end

  def after_sign_in_path_for(resource_or_scope)
    dashboard_path
  end


  rescue_from CanCan::AccessDenied, with: :access_denied

  private

    def access_denied(exception)
      respond_to do |format|
        format.json { render nothing: true, status: :forbidden }
        format.html {
          store_location_for :user, request.fullpath
          if user_signed_in?
            render :file => "#{Rails.root}/public/403.html", :status => 403
          else
            redirect_to new_user_session_path
          end
        }
      end

    end

    def email_redirect(user)
      user.email_redirect_accounts.order(:type_redir).select(&:persisted?)
    end

    def get_list(user)
      @lists_not_joined = Ml::List.all.includes(:users) - user.ml_lists
      @lists_joined = user.ml_lists
    end

  

end
