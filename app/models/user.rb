class User < ApplicationRecord
  # Validations
  validates :full_name, :email, presence: true
  validates :password, presence: true, confirmation: true, length: { minimum: 8 }, on: :create
  validates :password, presence: true, confirmation: true, length: { minimum: 8 }, allow_blank: true, on: :update
  enum :role, {
    admin: "admin",
    project_manager: "project manager",
    developer: "developer",
    tester: "tester"
  }

  # Relationships
  has_one_attached :profile_photo
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable, :lockable
  has_and_belongs_to_many :projects
  has_many :comments, as: :commentable
  has_one :bug
end
