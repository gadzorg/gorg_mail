# Preview all emails at http://localhost:3000/rails/mailers/external_invitation
class ExternalInvitationPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/external_invitation/send_invitation
  def send_invitation
    ExternalInvitation.send_invitation
  end

end
