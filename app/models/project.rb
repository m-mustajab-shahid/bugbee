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

  def admin?
    role == "admin"
  end

  def project_manager?
    role == "project_manager"
  end

  def developer?
    role == "developer"
  end

  def tester?
    role == "tester"
  end
end

# TODO: convert status field into enum (Done)
