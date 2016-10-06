class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  include ConfigurableEngine::ConfigurablesController

  before_filter :check_maintenance_mode

  after_filter :prepare_unobtrusive_flash
  private

  def after_sign_out_path_for(resource_or_scope)
    Rails.application.secrets.cas_provider_url ? "https://#{Rails.application.secrets.cas_provider_url}/cas/logout?service=#{root_url}" : root_url
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
      @lists_not_joined = user.lists_allowed_not_joined
      @lists_joined = user.ml_lists.includes(:users)
    end

    def check_maintenance_mode
      # caching maintenance state
      maintenance_mode = Rails.cache.fetch("maintenance_mode", expires_in: 1.minute){ Configurable[:maintenance_mode] }

      if maintenance_mode && controller_name != 'devise/sessions' && controller_name != 'static_page' && !current_user.nil?
        unless current_user.has_role?(:admin)  || current_user.has_role?(:support) || Configurable[:allowed_uuid_in_maintenance_mode].split.include?(current_user.uuid)
          cookies.delete(:secureusertokens)
          reset_session
          redirect_to root_path
        end
      end
    end

end
