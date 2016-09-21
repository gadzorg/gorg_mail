class EmailValidationMailer < ApplicationMailer
  
  def confirm_email(user,era, confirm_url)
    @user = user
    @era= era
    @confirmation_url= confirm_url
    mail(to: @era.redirect, subject: 'Confirmation de ton adresse email')
  end

  def notice_google_apps(user)
    @user = user

    not_borken_redirection = @user.email_redirect_accounts.where(type_redir: "smtp").select{|e| true unless e.broken?}.map(&:redirect)

    not_borken_redirection.each do |email|
      mail(to: email, subject: 'Ton compte Google Gadz.org est créé')
    end
  end

  end
