require 'rails_helper'

RSpec.describe TrackerRecord, type: :model do
  context 'associations' do
    it { is_expected.to belong_to :tracker }
  end
end
