json.extract! post, :id, :title, :description, :upvotes, :created_at, :updated_at
json.url post_url(post, format: :json)