require 'rails_helper'

RSpec.describe Tracker, type: :model do
  context 'validations' do
    it { is_expected.to validate_presence_of :title }
  end

  context 'associations' do
    it { is_expected.to belong_to :user}
    it { is_expected.to have_many :tracker_records }
  end

  context 'as_json' do
    let(:tracker) { create :tracker, :with_tracker_records }

    subject(:json) { tracker.as_json }

    it 'should include the default attributes' do
      tracker.attributes.each do |key, value|
        expect(json[key]).to eq value
      end
    end

    it 'should include the tracker_records' do
      expect(json['tracker_records']).to contain_exactly *tracker.tracker_records.as_json
    end
  end
end
