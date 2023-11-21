require 'rails_helper'

RSpec.describe User do
  subject(:user) { build(:user) }

  context 'with validations' do
    it { is_expected.to have_secure_password }
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_uniqueness_of(:email) }
    it { is_expected.to validate_length_of(:email).is_at_most(100) }
  end

  context 'with associations' do
    it { is_expected.to have_many(:organizations).through(:memberships) }
    it { is_expected.to have_many(:memberships).dependent(:destroy) }
    it { is_expected.to have_many(:sent_invitations).dependent(:destroy).class_name('Invitation') }
    it { is_expected.to have_many(:sent_invitations).with_foreign_key('sender_id').inverse_of(:sender) }
    it { is_expected.to have_many(:received_invitations).dependent(:destroy).class_name('Invitation') }
    it { is_expected.to have_many(:received_invitations).with_foreign_key('recipient_id').inverse_of(:recipient) }
  end

  describe '#admin?' do
    let(:user) { create(:user) }
    let(:role) { create(:role, name: role_name) }
    let(:organization) { create(:organization) }
    let(:organization_id) { organization.id }

    before do
      user.memberships.create!(role:, organization:)
    end

    context 'when user is an admin' do
      let(:role_name) { 'admin' }

      it 'returns true' do
        expect(user).to be_admin(organization_id)
      end
    end

    context 'when user is a member' do
      let(:role_name) { 'member' }

      it 'returns false' do
        expect(user).not_to be_admin(organization_id)
      end
    end

    context 'when user is an owner' do
      let(:role_name) { 'owner' }

      it 'returns false' do
        expect(user).not_to be_admin(organization_id)
      end
    end
  end

  describe '#member?' do
    let(:user) { create(:user) }
    let(:role) { create(:role, name: role_name) }
    let(:organization) { create(:organization) }
    let(:organization_id) { organization.id }

    before do
      user.memberships.create!(role:, organization:)
    end

    context 'when user is an admin' do
      let(:role_name) { 'admin' }

      it 'returns false' do
        expect(user).not_to be_member(organization_id)
      end
    end

    context 'when user is a member' do
      let(:role_name) { 'member' }

      it 'returns true' do
        expect(user).to be_member(organization_id)
      end
    end

    context 'when user is an owner' do
      let(:role_name) { 'owner' }

      it 'returns false' do
        expect(user).not_to be_member(organization_id)
      end
    end
  end

  describe '#owner?' do
    let(:user) { create(:user) }
    let(:role) { create(:role, name: role_name) }
    let(:organization) { create(:organization) }
    let(:organization_id) { organization.id }

    before do
      user.memberships.create!(role:, organization:)
    end

    context 'when user is an admin' do
      let(:role_name) { 'admin' }

      it 'returns false' do
        expect(user).not_to be_owner(organization_id)
      end
    end

    context 'when user is a member' do
      let(:role_name) { 'member' }

      it 'returns false' do
        expect(user).not_to be_owner(organization_id)
      end
    end

    context 'when user is an owner' do
      let(:role_name) { 'owner' }

      it 'returns true' do
        expect(user).to be_owner(organization_id)
      end
    end
  end
end
