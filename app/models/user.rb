class User < ApplicationRecord
  has_many :posts, inverse_of: :user, dependent: :destroy
  has_many :comments, inverse_of: :user, dependent: :destroy
  has_many :comment_reactions, class_name: 'Comment::Reaction', dependent: :destroy
end
