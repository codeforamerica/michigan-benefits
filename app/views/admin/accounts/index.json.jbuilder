json.array!(@accounts) do |account|
  json.extract! account, :id
  json.url admin_account_url(account, format: :json)
end
