class User < ApplicationRecord
  has_secure_password
  validates :name, :email, presence: true
  validates :email, uniqueness: true
  validates(:email, length: { maximum: 100 })

  has_many :memberships, dependent: :destroy
  has_many :organizations, through: :memberships
  has_many :sent_invitations, class_name: 'Invitation', foreign_key: 'sender_id', dependent: :destroy,
                              inverse_of: :sender
  has_many :received_invitations, class_name: 'Invitation', foreign_key: 'recipient_id', dependent: :destroy,
                                  inverse_of: :recipient

  def admin?(organization_id)
    role_exists?('admin', organization_id)
  end

  def member?(organization_id)
    role_exists?('member', organization_id)
  end

  def owner?(organization_id)
    role_exists?('owner', organization_id)
  end

  private

  def role_exists?(name, organization_id)
    Membership.includes(:role).where(user: self, organization_id:, role: { name: }).any?
  end
end
