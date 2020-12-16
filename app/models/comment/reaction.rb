class Comment
  class Reaction < ApplicationRecord
    self.inheritance_column = nil

    belongs_to :comment, inverse_of: :reactions
    belongs_to :user, inverse_of: :reactions

    enum(type: { like: 0, dislike: 1 })
  end
end
