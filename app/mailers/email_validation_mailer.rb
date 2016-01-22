class EmailValidationMailer < ApplicationMailer
  
  def confirm_email(user,era, confirm_url)
    @user = user
    @era= era
    @confirmation_url= confirm_url
    mail(to: @era.redirect, subject: 'Confirmation de ton adresse email')
  end
  
end
