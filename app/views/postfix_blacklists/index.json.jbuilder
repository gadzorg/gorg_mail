json.array!(@postfix_blacklists) do |postfix_blacklist|
  json.extract! postfix_blacklist, :id, :email, :reject_text, :commentary
  json.url postfix_blacklist_url(postfix_blacklist, format: :json)
end
