And(/^save html$/) do
  save_and_open_page
end

And (/^screenshot$/) do
  page.save_screenshot
end