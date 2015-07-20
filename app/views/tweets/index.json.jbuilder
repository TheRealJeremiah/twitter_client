json.array! @timeline do |tweet|
  json.full_text tweet.full_text
  json.user_name tweet.user.name
  json.created_at tweet.created_at
end
