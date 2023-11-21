require 'rails_helper'

RSpec.describe Organization do
  subject(:organization) { build(:organization) }

  context 'with validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name) }
  end

  context 'with associations' do
    it { is_expected.to have_many(:users).through(:memberships).inverse_of(:organizations) }
    it { is_expected.to have_many(:memberships).dependent(:destroy) }
    it { is_expected.to have_many(:invitations).dependent(:destroy) }
  end
end
