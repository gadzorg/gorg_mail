And(/^I have a redirection to "([^"]*)"$/) do |arg|
  FactoryGirl.create(:email_redirect_account, user: @me, redirect: arg)
end