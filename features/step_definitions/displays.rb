Then(/^"([^"]*)" contains "([^"]*)"$/) do |arg1, arg2|
  expect(page.first("##{arg1}")).to have_content(arg2)
end

Then(/^the page has button "([^"]*)"$/) do |title|
  expect(page).to  have_css("a[title=\"#{title}\"],input[type=\"submit\"][value=\"#{title}\"],a[data-tooltip=\"#{title}\"]") | have_link(title)
end

Then(/^"([^"]*)" does not contain "([^"]*)"$/) do |arg1, arg2|
  expect(page.first("##{arg1}")).not_to have_content(arg2)
end

When(/^I click "([^"]*)" button$/) do |title|
  click_link_or_button(title)
end

When(/^I click "([^"]*)" button in "((?:[^"]|\\")*)"$/) do |title,locator|
  within(:css, unescape(locator)) do
    click_link_or_button(title)
  end
end


When(/^I visit "([^"]*)"$/) do |arg|
  visit arg
end

And(/^I fill "([^"]*)" with "([^"]*)"$/) do |field,value|
  fill_in field, :with => value
end

And(/^I check box "([^"]*)"$/) do |arg|
  check(arg)
end

And (/^screenshot$/) do
  save_and_open_page

end

Then(/^the page contains "([^"]*)"$/) do |arg|
  expect(page.body).to have_content(arg)
end

Then(/^the page does not contains "([^"]*)"$/) do |arg|
  expect(page.body).not_to have_content(arg)
end

And(/^the page contains a button "([^"]*)"$/) do |arg|
  expect(page.body).to have_button(arg)
end