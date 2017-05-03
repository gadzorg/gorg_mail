class UnsubscribeController < ApplicationController

  layout 'no-menu'

  before_action :set_token, only: [:ml_form,:process_unsubscribe]

  def email_form
  end

  def send_verification_email
    UnsubscribeMlService.initialize_from_email(params[:email]).send_email_confirmation
  end

  def ml_form
      umls=UnsubscribeMlService.initialize_from_token(@token)
      @mls=umls.mailling_lists
      @has_account=umls.has_an_account?
  end

  def process_unsubscribe
      UnsubscribeMlService.initialize_from_token(@token).perform_unsubscribe(unsubcribe_params)
  end

  def set_token
    @token=Token.find_by(token: params.require(:token), scope: UnsubscribeMlService::TOKEN_SCOPE, used_at: nil)
    render :unknown_token unless @token
  end

  def unsubcribe_params
    params[:unsubscribe]||{}
  end
end
