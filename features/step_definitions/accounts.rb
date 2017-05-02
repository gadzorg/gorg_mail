Given(/^I have an account with ((?:[a-zA-Z_]+ ["'][^"']*["'](?:, )?)*)$/) do |raw_attrs|
  attrs=raw_attrs.split(",").map do |e|
    match=/([a-zA-Z_]+) "([^"]*)"/.match(e)
    [match[1],match[2]]
  end.to_h

  @me=FactoryGirl.create(:user, attrs)
end