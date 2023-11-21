require 'rails_helper'

RSpec.describe Metric do
  subject(:metric) { build(:metric) }

  context 'with validations' do
    let(:start_time) { '2023-10-30 23:00:00' }
    let(:date) { '2023-10-30' }

    it { is_expected.to validate_presence_of(:start_time) }
    it { is_expected.to validate_presence_of(:end_time) }
    it { is_expected.to validate_presence_of(:date) }

    it 'is invalid when start_time greater than end_time' do
      metric = build(:metric, start_time:, end_time: '2023-10-30 19:00:00', date:)
      metric.valid?
      expect(metric.errors.full_messages_for(:end_time)).to include(/End time must be greater than/)
    end

    it 'is invalid when start_time is equal to end_time' do
      metric = build(:metric, start_time:, end_time: start_time, date:)
      metric.valid?
      expect(metric.errors.full_messages_for(:end_time)).to include(/End time must be greater than/)
    end
  end

  context 'with associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:organization) }
  end
end
