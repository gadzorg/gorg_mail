json.array!(@email_source_accounts) do |email_source_account|
  json.extract! email_source_account, :id, :email, :email_virtual_domain, :type_source, :user_id
  json.url user_email_source_account_url(@user, email_source_account, format: :json)
end
