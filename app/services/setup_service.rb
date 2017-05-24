class SetupService

  def initialize(user)
    @user=user
  end

  def need_setup?
    @user.is_gadz && !(@user.email_source_accounts.any? && @user.email_redirect_accounts.any?)
  end

end