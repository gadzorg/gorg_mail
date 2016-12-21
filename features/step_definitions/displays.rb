Then(/^"([^"]*)" contains "([^"]*)"$/) do |arg1, arg2|
  expect(page.first("##{arg1}")).to have_content(arg2)
end

Then(/^the page has button "([^"]*)"$/) do |title|
  expect(page).to have_css("a[title=\"#{title}\"],input[type=\"submit\"][value=\"#{title}\"]")
end

Then(/^"([^"]*)" does not contain "([^"]*)"$/) do |arg1, arg2|
  expect(page.first("##{arg1}")).not_to have_content(arg2)
end

When(/^I click "([^"]*)" button$/) do |title|
  click_link_or_button(title)
end