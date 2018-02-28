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

Given(/^there is a public mailing lists with email "([^"]*)"$/) do |arg|
  @ml=FactoryGirl.create(:ml_list,
                         name: arg,
                         email: arg,
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

Given(/^I subscribed to the mailing list named "([^"]*)"$/) do |arg|
  @ml=Ml::List.find_by(name:arg)
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
  Ml::ExternalEmail.create(email: email, list_id: ml.id, enabled: true)
end

And(/^"([^"]*)" is subscribed to the closed mailinglist "([^"]*)" as an external member$/) do |email, name|
  ml=FactoryGirl.create(:ml_list,
                        name: name,
                        diffusion_policy: 'open',
                        inscription_policy: 'closed'
  )
  Ml::ExternalEmail.create(email: email, list_id: ml.id, enabled: true)
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

Given(/^the following mailing lists exists :$/) do |table|
  # table is a table.hashes.keys # => [:inscription_policy, :name]

  params= table.hashes.map do |ml_h|
    ml_h.map do |k,v|
      value= begin
        JSON.parse(v.to_s)
      rescue JSON::ParserError => e
        v
      end
      [k,value]
    end.to_h
  end


  params.each do |h|
    FactoryGirl.create(:ml_list,h )
  end
end


Then(/^user "([^"]*)" should be subscribed to mailinglist "([^"]*)"$/) do |hruid, ml_name|
  expect(Ml::List.find_by(name: ml_name).all_members).to include(User.find_by(hruid: hruid))
end

Then(/^I should be subscribed to mailinglist "([^"]*)"$/) do |ml_name|
  expect(Ml::List.find_by(name: ml_name).all_members).to include(@me)
end

Then(/^I should be subscribed to (\d+) mailinglists$/) do |n|
  expect(@me.lists.size).to eq(n.to_i)
end

Then(/^I should not be subscribed to any mailinglist$/) do
  expect(@me.lists).to be_empty
end