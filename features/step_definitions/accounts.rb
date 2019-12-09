Given(/^I have an account(?: with ((?:[a-zA-Z_]+ ["'][^"']*["'](?:, )?)*))?$/) do |raw_attrs|
  attrs=raw_attrs.to_s.split(",").map do |e|
    match=/([a-zA-Z_]+) "([^"]*)"/.match(e)
    [match[1],match[2]]
  end.to_h

  @me=FactoryBot.create(:user, attrs)
end

Given(/^I have an initialized account(?: with ((?:[a-zA-Z_]+ ["'][^"']*["'](?:, )?)*))?$/) do |raw_attrs|
  attrs=raw_attrs.to_s.split(",").map do |e|
    match=/([a-zA-Z_]+) "([^"]*)"/.match(e)
    [match[1],match[2]]
  end.to_h

  @me=FactoryBot.create(:user_with_addresses, attrs)
end

Given(/^I have a gadz account(?: with ((?:[a-zA-Z_]+ ["'][^"']*["'](?:, )?)*))?$/) do |arg|
  step "I have an initialized account with #{arg}"
  @me.update_attributes(is_gadz: true)
end

Given(/^I have a newly created gadz account(?: with ((?:[a-zA-Z_]+ ["'][^"']*["'](?:, )?)*))?$/) do |arg|
  step "I have an account with #{arg}"
  @me.update_attributes(is_gadz: true)
end

Given(/^I have a non-gadz account(?: with ((?:[a-zA-Z_]+ ["'][^"']*["'](?:, )?)*))?$/) do |arg|
  step "I have an initialized account with #{arg}"
  @me.update_attributes(is_gadz: false)
end

Given(/^I am logged in with (.*)$/) do |arg|
  step "I have #{arg}"
  step "I'm logged in"
end

Given(/^the following users exist :$/) do |table|
  # table is a table.hashes.keys # => [:is_gadz, :        hruid, :primary_email_source_account, :email]
  params= table.hashes.map do |ml_h|
    h_raw=ml_h.map do |k,v|
      value= begin
        JSON.parse(v.to_s)
      rescue JSON::ParserError => e
        v
      end
      [k,value]
    end.to_h

    h_raw.tap do |h|
      h['is_gadz'] = h['is_gadz'] == 'true' ? true : false
    end
  end

  params.each do |h|

    factory = h['primary_email_source_account'] ? :user_with_addresses : :user

    FactoryBot.create(factory,h )
  end
end
