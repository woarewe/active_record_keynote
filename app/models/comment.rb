class Comment < ApplicationRecord
  belongs_to :user, inverse_of: :comments
  belongs_to :post, inverse_of: :comments

  has_many :reactions, class_name: 'Reaction', dependent: :destroy, inverse_of: :comment
end
