json.extract! profile, :id, :account_id, :title, :avatar, :bio, :created_at, :updated_at
json.url profile_url(profile, format: :json)
json.avatar url_for(profile.avatar)
