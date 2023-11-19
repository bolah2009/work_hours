class Role < ApplicationRecord
  validates :name, presence: true
  validates :name, uniqueness: true

  has_many :memberships, dependent: :restrict_with_error
end
