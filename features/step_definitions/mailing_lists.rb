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
                         inscription_policy: 'closed'
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

Then(/^I become a member of the mailing list "([^"]*)"$/) do |arg|
  expect(Ml::List.find_by(name: arg).users).to include(@me)
end