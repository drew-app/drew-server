require 'rails_helper'

RSpec.describe Tag, type: :model do
  describe 'Validations' do
    let!(:tag) { create :tag }

    it { is_expected.to validate_uniqueness_of(:name).scoped_to(:user_id).case_insensitive }
  end
end
