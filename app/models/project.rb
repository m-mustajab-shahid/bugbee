class Project < ApplicationRecord
  validates :status, inclusion: { in: %w[active completed archived], message: "%{value} is not a valid project status" }
  validates :name, presence: true, on: :create
  validates :start_date, presence: true
  validates :end_date, comparison: { greater_than: :start_date }
  has_many :comments, as: :commentable


  has_and_belongs_to_many :users, dependent: :destroy
  has_many :bugs
  def admin?
    roles == "admin"
  end

  def project_manager?
    roles == "project_manager"
  end

  def developer?
    roles == "developer"
  end

  def tester?
    roles == "tester"
  end
end
