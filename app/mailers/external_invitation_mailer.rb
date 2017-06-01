class ExternalInvitationMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.external_invitation.send_invitation.subject
  #

  def send_invitation(email: nil, list: nil, token: nil)
    @email=email
    @token=token
    @list=list

    mail(to: email, subject: "Vous êtes invité à rejoindre le groupe \"#{@list.name}\"")
  end
end
