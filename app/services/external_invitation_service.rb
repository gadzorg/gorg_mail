class ExternalInvitationService

  class InvalidToken < StandardError; end
  class CguAcceptanceNeeded < StandardError; end
  class ExternalEmailNotFound < StandardError; end

  TOKEN_SCOPE='accept_external_invitation'

  def initialize( list:nil,
                  email: nil,
                  token: nil,
                  external_email: nil)
    @list=list
    @email=email
    @token=token
    @external_email=external_email
  end

  def invite
    send_invitation_mail
  end

  def send_invitation_mail
    ExternalInvitationMailer.send_invitation(email: @email, list: list, token: self.token).deliver_now
  end

  def external_email
    @external_email||= @token ? @token.tokenable||(raise ExternalEmailNotFound) : Ml::ExternalEmail.find_or_create_by(email: @email, list_id: list.id)
  end

  def token
    @token||=external_email.create_token(TOKEN_SCOPE)
  end

  def list
    @list||=external_email.ml_list
  end

  def accept_invitation(accept_cgu)
    if accept_cgu
      token.set_used
      external_email.enabled=true
      external_email.accepted_cgu_at=DateTime.now
      external_email.save&&list.sync_with_mailing_list_service
    else
      raise CguAcceptanceNeeded
    end
  end

  def decline_invitation
    list.remove_email(external_email)
    token.set_used # will be destroyed by mailing callback anyway
  end


  def self.initialize_from_email(email: nil, list: nil)
    self.new(email:email, list:list)
  end

  def self.initialize_from_token(token)
    raise InvalidToken unless token.scope == TOKEN_SCOPE
    self.new(token: token)
  end

end
