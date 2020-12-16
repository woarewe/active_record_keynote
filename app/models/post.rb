class Post < ApplicationRecord
  belongs_to :user, inverse_of: :posts, dependent: :destroy

  has_many :comments, inverse_of: :post, dependent: :destroy
end
