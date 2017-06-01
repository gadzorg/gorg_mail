Then(/^"(.*)" receive an email with object "((?:[^"]|\\")*)"$/) do |email_address, subject|
  email=ActionMailer::Base.deliveries.last
  expect(email).to have_attributes(
                       from: ["gorgu@gadz.org"],
                       to: [email_address],
                       subject: YAML.load(%Q(---\n"#{subject}"\n))
                   )

end