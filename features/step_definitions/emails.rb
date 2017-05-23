Then(/^"(.*)" receive an email with object "((?:[^"]|\\")*)"$/) do |email_address, subject|
  email=ActionMailer::Base.deliveries.last
  expect(email).to have_attributes(
                       from: ["gorgu@gadz.org"],
                       to: [email_address],
                       subject: YAML.load(%Q(---\n"#{subject}"\n))
                   )

end

And(/^this email contains "([^"]*)"$/) do |arg|
  pending
end


And(/^this email contains a link "([^"]*)"(?: to "([^"]*)")?$/) do |title,url|
  email=ActionMailer::Base.deliveries.last
  url||=title
  expect(email.body).to have_link(title, :href => url)
end


And(/^this email contains a text matching \/(.*)\/$/) do |regex_text|
  email=ActionMailer::Base.deliveries.last
  expect(email.body.parts.map(&:encoded)[0]).to match(Regexp.new(regex_text))
  expect(email.body.parts.map(&:encoded)[1]).to match(Regexp.new(regex_text))
end