Then(/^"(.*)" receive an email with object "([^"]*)"$/) do |email_address, arg|
  email=ActionMailer::Base.deliveries.last
  expect(email).to have_attributes(
                       from: ["gorgu@gadz.org"],
                       to: [email_address],
                       subject: arg
                   )

end