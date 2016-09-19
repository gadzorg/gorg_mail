class EmailValidationMailer < ApplicationMailer
  
  def confirm_email(user,era, confirm_url)
    @user = user
    @era= era
    @confirmation_url= confirm_url
    mail(to: @era.redirect, subject: 'Confirmation de ton adresse email')
  end

  def notice_google_apps(user)
    @user = user
    mail(to: @user.email, subject: 'Ton compte Google Gadz.org est créé')
  end

  end
