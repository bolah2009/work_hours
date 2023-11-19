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
end
