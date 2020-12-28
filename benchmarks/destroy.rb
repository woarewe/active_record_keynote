require_relative '../config/environment'

class Service
  def self.dependent_destroy(*user_ids)
    ActiveRecord::Base.transaction do
      User.where(id: user_ids).destroy_all

      raise ActiveRecord::Rollback
    end
  end

  def self.custom_deleting(*user_ids)
    ActiveRecord::Base.transaction do
      Comment::Reaction.where(user_id: user_ids).delete_all
      Comment::Reaction.joins(comment: [post: :user]).where(users: { id: user_ids }).delete_all
      Comment::Reaction.joins(:comment).where(comments: { user_id: user_ids }).delete_all
      Comment.where(user_id: user_ids).delete_all
      Comment.joins(post: :user).where(users: { id: user_ids }).delete_all
      Post.joins(:user).where(users: { id: user_ids }).delete_all
      User.where(id: user_ids).delete_all

      raise ActiveRecord::Rollback
    end
  end

  def self.on_delete_cascade(*user_ids)
    ActiveRecord::Base.transaction do
      User.where(id: user_ids).delete_all

      raise ActiveRecord::Rollback
    end
  end
end

Benchmark.ips do |x|
  x.report('dependent destroy') { Service.dependent_destroy(User.ids.sample) }

  x.report('custom deleting') { Service.custom_deleting(User.ids.sample) }

  x.report('on delete cascade') { Service.on_delete_cascade(User.ids.sample) }

  x.compare!
end

# Benchmark.bm(15) do |x|
#   x.report('dependent destroy') { Service.dependent_destroy(User.ids.sample) }
#
#   x.report('custom deleting') { Service.custom_deleting(User.ids.sample) }
# end
