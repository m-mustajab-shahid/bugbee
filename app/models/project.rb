class Project < ApplicationRecord
  validates :status, inclusion: { in: %w[active completed archived], message: "%{value} is not a valid project status" }
  validates :name, presence: true, on: :create
  validates :start_date, presence: true


  has_and_belongs_to_many :users, dependent: :destroy
  has_many :bugs
end
