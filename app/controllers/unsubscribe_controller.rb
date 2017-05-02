class UnsubscribeController < ApplicationController
  def email_form
  end

  def send_verification_email
    UnsubscribeMlService.initialize_from_email(params[:email]).send_email_confirmation
  end

  def ml_form
    token=Token.find_by(token: params[:token], scope: UnsubscribeMlService::TOKEN_SCOPE, used_at: nil)
    if token
      @mls=UnsubscribeMlService.initialize_from_token(token).mailling_lists
      @token=params[:token]
    else
      render :unknown_token
    end
  end

  def process_unsubscribe

    token=Token.find_by(token: params[:token], scope: UnsubscribeMlService::TOKEN_SCOPE, used_at: nil)
    if token
      unsubcribe_params=params.require(:unsubscribe)
      UnsubscribeMlService.initialize_from_token(token).perform_unsubscribe(unsubcribe_params)
      @token=params[:token]
    else
      render :unknown_token
    end

  end
end
