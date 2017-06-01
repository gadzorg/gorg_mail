Then(/^a token is created$/) do
  Token.count>0
end

And(/^this email contains a link to use the token$/) do
  email=ActionMailer::Base.deliveries.last
  expect(email.body.encoded).to include(Token.last.token)
end

Given(/^there is the unsubscribe token "([^"]*)" created for email address "([^"]*)"$/) do |token_value, email|
  token=UnsubscribeMlService.initialize_from_email(email).token.tap do |t|
    t.token=token_value
    t.save
  end
end