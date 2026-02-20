class User < ApplicationRecord
  validates :full_name, :email, presence: true
  # validates :password, confirmation: true, length: { minimum: 8 }, on: :update
  validates :password, presence: true, confirmation: true, length: { minimum: 8 }, on: :create
  validates :roles, inclusion: { in: %w[admin project_manager developer tester], message: "%{value} is not a valid roles" }
  has_one_attached :profile_photo

  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable
  has_and_belongs_to_many :projects
  has_one :bug
end
