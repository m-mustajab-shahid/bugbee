class Project < ApplicationRecord
  validates :status, inclusion: { in: %w[active completed archived], message: "%{value} is not a valid project status" }
  validates :name, presence: true, on: :create
  validates :start_date, presence: true
  validates :end_date, comparison: { greater_than: :start_date }
  has_many :comments, as: :commentable

  has_and_belongs_to_many :users, dependent: :destroy
  has_many :bugs

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

# TODO: convert status field into enum
