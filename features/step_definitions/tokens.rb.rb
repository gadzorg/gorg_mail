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

And(/^this email contains a link with a token$/) do
  steps %Q{
    Given a token is created
    Given this email contains a link to use the token
  }
end

Given(/^"([^"]*)" was invited to join the mailing list named "([^"]*)" with token "([^"]*)"$/) do |email, list, token_value|
  ml=Ml::List.find_by(name: list)
  token=ExternalInvitationService.initialize_from_email(email:email,list:ml).token.tap do |t|
    t.token=token_value
    t.save
  end
end

And(/^the token "([^"]*)" is used$/) do |arg|
  expect(Token.find_by(token: arg)).to be_used
end

And(/^the token "([^"]*)" is destroyed$/) do |arg|
  expect(Token.find_by(token: arg)).to be_nil
end
