require 'rails_helper'

RSpec.describe 'TagsController routing', type: :routing do
  it { expect(get('/api/tags')).to route_to(controller: 'tags', action: 'index') }
  it { expect(post('/api/tags')).to_not be_routable }
  it { expect(put('/api/tags/1')).to_not be_routable }
  it { expect(get('/api/tags/1')).to_not be_routable }
  it { expect(delete('/api/tags/1')).to_not be_routable }
end

RSpec.describe TagsController, type: :controller do
  let(:user) { create :user }
  let(:other_user) { create :user }

  before do
    sign_in_user user
  end

  describe '#index' do
    let!(:tags) { [] }

    before { get 'index' }

    subject(:data) { JSON.parse(response.body) }

    context 'with no tags' do
      it { expect(response).to be_successful }
      it { expect(data).to eq [] }
    end

    context 'with some tasg' do
      let!(:tags) { create_list :tag, 3, user: user }

      it { expect(response).to be_successful }
      it { expect(data.length).to eq 3 }

      context 'tag attributes' do
        let(:source_names) { tags.collect(&:name) }

        subject(:response_names) { data.map { |t| t['name'] } }

        it { expect(response_names).to contain_exactly(*source_names) }
      end
    end

    context 'with tags from another user' do
      let!(:tags) { create_list :tag, 3, user: other_user }

      it { expect(response).to be_successful }
      it { expect(data).to eq [] }
    end
  end
end
