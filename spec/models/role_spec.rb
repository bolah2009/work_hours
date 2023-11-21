require 'rails_helper'

RSpec.describe Role do
  subject(:role) { build(:role) }

  context 'with validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name) }
  end

  context 'with associations' do
    it { is_expected.to have_many(:memberships).dependent(:restrict_with_error) }
  end
end
