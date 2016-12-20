Given(/^I'm a Gadz member$/) do
  @me=FactoryGirl.create(:user_with_addresses,
    email: "my_email@example.com",
    password: "secret",
    is_gadz: true,
    uuid: "559bb0aa-ddac-4607-ad41-7e520ee40819"
  )
  gam=GramAccountMocker.for({})
  gam.mock_get_request
end

And(/^I'm logged in$/) do
  visit new_user_session_path
  fill_in "user_email", :with => @me.email
  fill_in "user_password", :with => @me.password
  click_button "Connexion"
end