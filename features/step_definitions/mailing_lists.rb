When(/^I visit to mailing lists index$/) do
  visit "mailinglists"
end

Given(/^there is a public mailing lists named "([^"]*)"$/) do |arg|
  @ml=FactoryGirl.create(:ml_list,
                         name: arg,
                         diffusion_policy: 'open',
                         inscription_policy: 'open'
  )
end

And(/^there is a group\-only mailing lists named "([^"]*)" for group "([^"]*)"$/) do |arg1, arg2|
  @ml=FactoryGirl.create(:ml_list,
                         name: arg1,
                         diffusion_policy: 'open',
                         inscription_policy: 'in_group',
                         group_uuid: arg2
  )
end

Given(/^there is a closed mailing lists named "([^"]*)"$/) do |arg|
  @ml=FactoryGirl.create(:ml_list,
                         name: arg,
                         diffusion_policy: 'open',
                         inscription_policy: 'closed'
  )
end

Given(/^I subscribed to a public mailing lists named "([^"]*)"$/) do |arg|
  @ml=FactoryGirl.create(:ml_list,
                         name: arg,
                         diffusion_policy: 'open',
                         inscription_policy: 'open'
  )
  @ml.add_user_no_sync(@me)
end

And(/^I subscribed to a group\-only mailing lists named "([^"]*)" for group "([^"]*)"$/) do |arg1, arg2|
  @ml=FactoryGirl.create(:ml_list,
                         name: arg1,
                         diffusion_policy: 'open',
                         inscription_policy: 'in_group',
                         group_uuid: arg2
  )
  @ml.add_user_no_sync(@me)
end

Given(/^I subscribed to a closed mailing lists named "([^"]*)"$/) do |arg|
  @ml=FactoryGirl.create(:ml_list,
                         name: arg,
                         diffusion_policy: 'open',
                         inscription_policy: 'closed'
  )
  @ml.add_user_no_sync(@me)
end

And(/^"([^"]*)" is subscribed to the public mailinglist "([^"]*)" as an external member$/) do |email, name|
  ml=FactoryGirl.create(:ml_list,
                        name: name,
                        diffusion_policy: 'open',
                        inscription_policy: 'open'
  )
  Ml::ExternalEmail.create(email: email, list_id: ml.id)
end

And(/^"([^"]*)" is subscribed to the closed mailinglist "([^"]*)" as an external member$/) do |email, name|
  ml=FactoryGirl.create(:ml_list,
                        name: name,
                        diffusion_policy: 'open',
                        inscription_policy: 'closed'
  )
  Ml::ExternalEmail.create(email: email, list_id: ml.id)
end

Then(/^I am (?:no longer|remains not) a member of "([^"]*)"$/) do |arg|
  expect(Ml::List.find_by(name: arg).all_members).not_to include(@me)
end

And(/^I (?:becomes|remains) a member of "([^"]*)"$/) do |arg|
  expect(Ml::List.find_by(name: arg).all_members).to include(@me)
end

Then(/^"([^"]*)" is not an external member of "([^"]*)"$/) do |email, ml_name|
  expect(Ml::List.find_by(name: ml_name).ml_external_emails.pluck(:email)).not_to include(email)
end

And(/^"([^"]*)" is an external member of "([^"]*)"$/) do |email, ml_name|
  expect(Ml::List.find_by(name: ml_name).ml_external_emails.pluck(:email)).to include(email)
end

When(/^I visit the page of the mailling list "([^"]*)"$/) do |arg|
  visit ml_list_path(Ml::List.find_by(name: arg))
end

And(/^I am admin of the list "([^"]*)"$/) do |arg|
  ml=Ml::List.find_by(name: arg)
  ml.add_user_no_sync(@me)
  ml.set_role(@me, :admin)
end

And(/^"([^"]*)" (?:becomes|remains) subscribed to the mailinglist "([^"]*)" as an inactive external member$/) do |email, ml_name|
  externals=Ml::List.find_by(name: ml_name).ml_external_emails
  expect(externals.map {|e| e.email}).to include(email)
  expect(externals.find {|e| e.email==email}).to have_attributes(
                                                     enabled: false,
                                                     accepted_cgu_at: nil
                                                 )
end

And(/^"([^"]*)" (?:becomes|remains) subscribed to the mailinglist "([^"]*)" as an active external member$/) do |email, ml_name|
  externals=Ml::List.find_by(name: ml_name).ml_external_emails
  expect(externals.map {|e| e.email}).to include(email)
  external=externals.find {|e| e.email==email}
  expect(external).to have_attributes(
                          enabled: true,
                      )
  expect(external).not_to have_attributes(
                              accepted_cgu_at: nil,
                          )
end

When(/^external member "([^"]*)" is deleted from "([^"]*)"$/) do |email, ml_name|
  externals=Ml::List.find_by(name: ml_name).ml_external_emails
  external=externals.find {|e| e.email==email}
  external.destroy
end