And(/^I have a primary source email "([^"]*)"$/) do |arg|
  local_part,domain_part=arg.split('@')
  evd=EmailVirtualDomain.find_or_create_by(name:domain_part)
  evd.update_attributes(aliasing: evd.id) unless evd.aliasing
  FactoryGirl.create(:email_source_account, user: @me, primary: true,email: local_part, email_virtual_domain:evd)
end