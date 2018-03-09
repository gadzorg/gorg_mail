Then(/^"([^"]*)" contains "([^"]*)"$/) do |arg1, arg2|
  expect(page.first("##{arg1}")).to have_content(arg2)
end

Then(/^the page has button "([^"]*)"$/) do |title|
  expect(page).to  have_css("a[title=\"#{title}\"],input[type=\"submit\"][value=\"#{title}\"],a[data-tooltip=\"#{title}\"]")|have_link(title)|have_button(title)
end

Then(/^"([^"]*)" does not contain "([^"]*)"$/) do |arg1, arg2|
  expect(page.first("##{arg1}")).not_to have_content(arg2)
end


When(/^I click "([^"]*)" button in "((?:[^"]|\\")*)"$/) do |title,locator|
  within(:css, unescape(locator)) do
    click_link_or_button(title)
  end
  wait_for_ajax
end

When(/^I click "([^"]*)" button$/) do |title|
  click_link_or_button(title)
  wait_for_ajax
end

When(/^I visit "([^"]*)"$/) do |arg|
  visit arg
end

Then(/^I am redirected to "([^"]*)"$/) do |arg|
  expect(page.current_path).to eq(arg)
end

Then(/^I should be forbidden to access the ressource$/) do
  expect(page.status_code).to eq(403)
  expect(page.body).to have_content('Erreur 403 - Forbidden')
end

Then(/^I should be authorized to access the ressource$/) do
  expect(page.status_code).not_to eq(403)
  expect(page.body).not_to have_content('Erreur 403 - Forbidden')
end


And(/^I fill "([^"]*)" with "([^"]*)"$/) do |field,value|
  fill_in field, :with => value
end

And(/^I check box "([^"]*)"$/) do |arg|
  check(arg)
end

Then(/^the page contains "([^"]*)"$/) do |arg|
  expect(page.body).to have_content(arg)
end

Then(/^the page does not contains "([^"]*)"$/) do |arg|
  expect(page.body).not_to have_content(arg)
end

Then(/^the page contains a field "([^"]*)"$/) do |arg|
  expect(page.body).to have_field(arg)
end

Then(/^the page does not contains a field "([^"]*)"$/) do |arg|
  expect(page.body).not_to have_field(arg)
end
