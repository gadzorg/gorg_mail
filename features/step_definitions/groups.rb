require 'gram_v2_client/rspec/gram_account_mocker'

Given(/^I'm in group "([^"]*)"$/) do |arg|
  gam=GramAccountMocker.for(attr:{

      uuid: @me.uuid,
      groups: [
      {
          uuid: "76dd86c5-02f9-4b21-aee4-5d4622a44995",
          short_name: "Fun Private Group",
          name: "private_group",
          description: "Test",
          url: "/api/v2/groups/76dd86c5-02f9-4b21-aee4-5d4622a44995"
      }
  ]},auth: GramAccountMocker.http_basic_auth_header(Rails.application.secrets.gram_api_user,
                                                    Rails.application.secrets.gram_api_password))
  gam.mock_get_request
end

Given(/^there is a group named "([^"]*)"$/) do |arg|
  "76dd86c5-02f9-4b21-aee4-5d4622a44995"
end