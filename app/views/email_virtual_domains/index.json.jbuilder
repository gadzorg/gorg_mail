json.array!(@email_virtual_domains) do |email_virtual_domain|
  json.extract! email_virtual_domain, :id, :name, :aliasing
  json.url email_virtual_domain_url(email_virtual_domain, format: :json)
end
