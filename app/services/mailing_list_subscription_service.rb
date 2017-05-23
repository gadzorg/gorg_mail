class MailingListSubscriptionService

  def initialize(list:nil, user:nil)
    @list=list
    @user=user
  end

  def subscribe_email(email)
    @user=EmailFinder.new(email,priority_array: [EmailSourceAccount,EmailRedirectAccount,User]).find_one
    if @user
      self.do_subscribe
    else
      ExternalInvitationService.initialize_from_email(email: email, list: @list).invite
    end
  end

  def do_subscribe
    if @list.add_user(@user)
      send_confirmation_mail
      true
    else
      false
    end
  end

  def send_confirmation_mail
    MailingListsSubscriptionMailer.send_subscription_confirmation(user: @user, list: @list).deliver_now
  end
end