class MailingListsSubscriptionMailer < ApplicationMailer


  def send_subscription_confirmation(user: nil, list: nil)
    @user=user
    @list=list

    mail(to: user.contact_email, subject: "Vous avez rejoins le groupe de discussion \"#{@list.name}\"")
  end
end