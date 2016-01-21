json.array!(@email_redirect_accounts) do |email_redirect_account|
  json.extract! email_redirect_account, :id, :redirect, :flag, :type_redir, :user_id
  json.url user_email_redirect_account_url(@user, email_redirect_account, format: :json)
end
