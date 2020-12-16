ActiveRecord::Base.logger = Logger.new($stdout)

users_data = Array.new(100) do
  {
    username: Faker::Internet.username,
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    created_at: Time.now,
    updated_at: Time.now
  }
end

user_ids = User.insert_all!(users_data).map { |row| row.fetch('id') }

post_ids = user_ids.flat_map do |user_id|
  data = Array.new(10) do
    {
      user_id: user_id,
      title: Faker::Lorem.sentence,
      body: Faker::Lorem.paragraph,
      created_at: Time.now,
      updated_at: Time.now
    }
  end
  Post.insert_all!(data).map { |row| row.fetch('id') }
end

comment_ids = post_ids.flat_map do |post_id|
  data = Array.new(20) do
    {
      user_id: user_ids.sample,
      post_id: post_id,
      body: Faker::Lorem.paragraph,
      created_at: Time.now,
      updated_at: Time.now
    }
  end
  Comment.insert_all!(data).map { |row| row.fetch('id') }
end

comment_reaction_ids = comment_ids.flat_map do |comment_id|
  data = Array.new(10) do
    {
      comment_id: comment_id,
      user_id: user_ids.sample,
      type: Comment::Reaction.types.values.sample,
      created_at: Time.now,
      updated_at: Time.now
    }
  end
  Comment::Reaction.insert_all!(data).map { |row| row.fetch('id') }
end
