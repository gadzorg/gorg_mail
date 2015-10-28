json.array!(@users) do |user|
  json.extract! user, :id, :email, :firstname, :lastname, :hruid
  json.url user_url(user, format: :json)
end
