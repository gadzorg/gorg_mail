json.array!(@aliases) do |alias|
  json.extract! alias, :id
  json.url alias_url(alias, format: :json)
end
