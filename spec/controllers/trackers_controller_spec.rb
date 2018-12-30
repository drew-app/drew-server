require 'rails_helper'

RSpec.describe 'TrackersController routing', type: :routing do
  it { expect(get('/api/trackers')).to route_to(controller: 'trackers', action: 'index') }
  it { expect(post('/api/trackers')).to route_to(controller: 'trackers', action: 'create') }
  it { expect(put('/api/trackers/1')).to_not be_routable }
  it { expect(get('/api/trackers/1')).to_not be_routable }
  it { expect(delete('/api/trackers/1')).to_not be_routable }
end

RSpec.describe TrackersController, type: :controller do
  let(:user) { create :user }
  let(:other_user) { create :user }

  before do
    sign_in_user user
  end

  describe '#index' do
    let!(:trackers) { [] }

    before { get 'index' }

    subject(:data) { JSON.parse(response.body) }

    context 'with no trackers' do
      it { expect(response).to be_successful }
      it { expect(data).to eq [] }
    end

    context 'with some trackers' do
      let!(:trackers) { create_list :tracker, 3, user: user }

      it { expect(response).to be_successful }
      it { expect(data.length).to eq 3 }

      context 'tracker attributes' do
        let(:source_titles) { trackers.collect(&:title) }

        subject(:response_titles) { data.map { |t| t['title'] } }

        it { expect(response_titles).to contain_exactly(*source_titles) }
      end
    end

    context 'with trackers from another user' do
      let!(:trackers) { create_list :tracker, 3, user: other_user }

      it { expect(response).to be_successful }
      it { expect(data).to eq [] }
    end
  end

  describe '#create' do
    context 'valid create' do
      before { post 'create', params: { tracker: tracker_params } }

      let(:tracker_params) { attributes_for :tracker }

      it { expect(response).to be_successful }

      context 'response body' do
        subject(:data) { JSON.parse(response.body) }

        its(['title']) { is_expected.to eq tracker_params[:title] }
      end

      context 'new model' do
        subject(:new_tracker) { Tracker.last }

        its(:title) { is_expected.to eq tracker_params[:title] }
        its(:user) { is_expected.to eq user }
      end
    end

    context 'invalid attributes' do
      let(:tracker_params) { attributes_for :tracker, title: '' }

      it 'should raise a validation error' do
        expect {
          post 'create', params: { tracker: tracker_params }
        }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end
end
