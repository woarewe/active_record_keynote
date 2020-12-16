ActiveRecord::Base.logger = Logger.new($stdout)

users_data = Array.new(10_000) do
  {
    username: Faker::Internet.username,
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    created_at: Time.now,
    updated_at: Time.now
  }
end

user_ids = User.insert_all!(users_data).map { |row| row.fetch('id') }

posts_data = user_ids.flat_map do |user_id|
  Array.new(100) do
    {
      user_id: user_id,
      title: Faker::Lorem.sentence,
      body: Faker::Lorem.paragraph,
      created_at: Time.now,
      updated_at: Time.now
    }
  end
end

post_ids = Post.insert_all!(posts_data).map { |row| row.fetch('id') }

comments_data = post_ids.flat_map do |post_id|
  Array.new(1000) do
    {
      user_id: user_ids.sample,
      post_id: post_id,
      body: Faker::Lorem.paragraph,
      created_at: Time.now,
      updated_at: Time.now
    }
  end
end

comment_ids = Comment.insert_all!(comments_data).map { |row| row.fetch('id') }

comment_reactions_data = comment_ids.flat_map do |comment_id|
  Array.new(100) do
    {
      comment_id: comment_id,
      user_id: user_ids.sample,
      type: Comment::Reaction.types.values.sample,
      created_at: Time.now,
      updated_at: Time.now
    }
  end
end

comment_reaction_ids = Comment::Reaction.insert_all!(comment_reactions_data).map { |row| row.fetch('id') }
