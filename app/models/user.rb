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
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable
  has_and_belongs_to_many :projects
  has_many :comments, as: :commentable
  has_one :bug

  # TODO: Rename roles -> role, without losing any data + without updating exisiting migrations (Done)
  # TODO: Convert into enum (Done)
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
