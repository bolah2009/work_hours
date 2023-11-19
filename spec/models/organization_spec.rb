require 'rails_helper'

RSpec.describe Organization do
  subject(:organization) { build(:organization) }

  context 'with validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name) }
  end
end
