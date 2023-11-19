class Organization < ApplicationRecord
  validates :name, presence: true
  validates :name, uniqueness: true

  has_many :memberships, dependent: :destroy
  has_many :users, through: :memberships
  has_many :invitations, dependent: :destroy
  has_many :metrics, dependent: :restrict_with_error
end
