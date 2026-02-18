class User < ApplicationRecord
  validates :full_name, :email, presence: true
  validates :password, confirmation: true
  has_one_attached :profile_photo

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_and_belongs_to_many :projects
  has_one :bug
end
