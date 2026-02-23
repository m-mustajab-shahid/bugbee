class Comment < ApplicationRecord
  validates :body, presence: { message: "field cannot be blank" }
  belongs_to :user
  belongs_to :commentable, polymorphic: true
end
