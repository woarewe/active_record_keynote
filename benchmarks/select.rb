require_relative '../config/environment'

class Service
  def self.call(user)
    user.posts.each do |post|
      post.comments.each do |comment|
        comment.reactions.select { |reaction| reaction.like? }
      end
    end
  end

  def self.without_includes(id)
    user = User.find(id)
    call(user)
  end

  def self.with_includes(id)
    user = User.includes(posts: [comments: :reactions]).find(id)
    call(user)
  end
end

Benchmark.ips do |x|
  x.report('without includes') { Service.without_includes(User.ids.sample) }

  x.report('with includes') { Service.with_includes(User.ids.sample) }

  x.compare!
end
