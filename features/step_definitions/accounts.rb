Given(/^I have an account with ((?:[a-zA-Z_]+ ["'][^"']*["'](?:, )?)*)$/) do |raw_attrs|
  attrs=raw_attrs.split(",").map do |e|
    match=/([a-zA-Z_]+) "([^"]*)"/.match(e)
    [match[1],match[2]]
  end.to_h

  @me=FactoryGirl.create(:user, attrs)
end

Given(/^I have an initialized account with ((?:[a-zA-Z_]+ ["'][^"']*["'](?:, )?)*)$/) do |raw_attrs|
  attrs=raw_attrs.split(",").map do |e|
    match=/([a-zA-Z_]+) "([^"]*)"/.match(e)
    [match[1],match[2]]
  end.to_h

  @me=FactoryGirl.create(:user_with_addresses, attrs)
end

Given(/^I have a gadz account with ((?:[a-zA-Z_]+ ["'][^"']*["'](?:, )?)*)$/) do |arg|
  step "I have an initialized account with #{arg}"
  @me.update_attributes(is_gadz: true)
end

Given(/^I am logged in with (.*)$/) do |arg|
  step "I have #{arg}"
  step "I'm logged in"
end