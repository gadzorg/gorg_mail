And(/^I have a redirection to "([^"]*)"$/) do |arg|
  FactoryBot.create(:email_redirect_account, user: @me, redirect: arg)
end

Then(/^my redirect address "([^"]*)" is created$/) do |arg|
  expect(@me.email_redirect_accounts.smtp.map(&:redirect)).to include(arg)
end
