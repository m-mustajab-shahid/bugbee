class Project < ApplicationRecord
  # Validations
  enum :status, { active: "active", completed: "completed", archived: "archived" }
  validates :name, presence: true
  validates :start_date, presence: true
  validates :end_date, comparison: { greater_than: :start_date }

  # Relationships
  has_many :comments, as: :commentable
  has_and_belongs_to_many :users, dependent: :destroy
  has_many :bugs, dependent: :destroy
end
