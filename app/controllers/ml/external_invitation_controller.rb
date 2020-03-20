class Ml::ExternalInvitationController < ApplicationController

  layout 'no-menu'

  before_action :set_token, only: [:accept_invitation, :decline_invitation, :accept_cgu]
  rescue_from ExternalInvitationService::InvalidToken, with: :unknown_token

  def accept_cgu
    begin
      service=ExternalInvitationService.initialize_from_token(@token)
      if service.accept_invitation(params[:accept_cgu]=="1")
        @list=service.list

      else
        redirect_to ml_accept_external_invitation_path(@token.token), :flash => { :error => "Impossible d'enregistrer l'inscription" }
      end
    rescue ExternalInvitationService::CguAcceptanceNeeded
      redirect_to ml_accept_external_invitation_path(@token.token, cgu_retry:true)
    end
  end

  def accept_invitation
    service=ExternalInvitationService.initialize_from_token(@token)
    @cgu_retry=params[:cgu_retry]
    @list=service.list
    @email=service.external_email.email
  end

  def decline_invitation
    service = ExternalInvitationService.initialize_from_token(@token)
    service.decline_invitation

    @list = service.list
  end

  def set_token
    @token=Token.usable.find_by(token: params.require(:token))
    unknown_token unless @token
  end

  def unknown_token
    render 'shared/unknown_token'
  end
end
