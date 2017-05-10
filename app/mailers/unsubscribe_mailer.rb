class UnsubscribeMailer < ApplicationMailer

  def confirm_email(email, token)
    @email=email
    @token=token
    mail(to: email, subject: "Confirmez votre adresse mail pour vous désabonner")
  end

end