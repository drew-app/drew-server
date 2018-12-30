require 'rails_helper'

RSpec.describe User, type: :model do
  context 'associations' do
    it { is_expected.to have_many :tasks }
    it { is_expected.to have_many :tags }
    it { is_expected.to have_many :trackers }
  end
end
