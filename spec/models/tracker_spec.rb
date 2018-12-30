require 'rails_helper'

RSpec.describe Tracker, type: :model do
  context 'validations' do
    it { is_expected.to validate_presence_of :title }
  end

  context 'associations' do
    it { is_expected.to belong_to :user}
  end
end
