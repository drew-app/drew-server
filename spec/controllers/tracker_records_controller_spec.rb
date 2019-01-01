require 'rails_helper'

RSpec.describe 'TrackersController routing', type: :routing do
  it { expect(get('/api/trackers/1/tracker_records')).to(
    route_to(controller: 'tracker_records', action: 'index', tracker_id: '1')
  ) }
  it { expect(post('/api/trackers/1/tracker_records')).to(
    route_to(controller: 'tracker_records', action: 'create', tracker_id: '1')
  ) }
  it { expect(put('/api/trackers/1/tracker_records/1')).to_not be_routable }
  it { expect(get('/api/trackers/1/tracker_records/1')).to_not be_routable }
  it { expect(delete('/api/trackers/1/tracker_records/1')).to_not be_routable }
end

RSpec.describe TrackerRecordsController, type: :controller do
  let(:user) { create :user }
  let(:other_user) { create :user }

  let!(:tracker) { create :tracker, user: user }
  let!(:tracker_id) { tracker.id }

  before do
    sign_in_user user
  end

  describe '#index' do
    context 'valid index' do
      let!(:tracker_records) { [] }

      before { get 'index', params: { tracker_id: tracker_id } }

      subject(:data) { JSON.parse(response.body) }

      context 'with no tracker records' do
        it { expect(response).to be_successful }
        it { expect(data).to eq [] }
      end

      context 'with some tracker records' do
        let!(:tracker_records) { create_list :tracker_record, 3, tracker: tracker }

        it { expect(response).to be_successful }
        it { expect(data.length).to eq 3 }
      end

      context 'with tracker records from another tracker' do
        let!(:other_tracker) { create :tracker, user: user }
        let!(:tracker_records) { create_list :tracker_record, 3, tracker: other_tracker }

        it { expect(response).to be_successful }
        it { expect(data).to eq [] }
      end
    end

    context 'for tracker that does not exist' do
      it 'should throw an exception' do
        expect {
          get 'index', params: { tracker_id: 'bullshit' }
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe '#create' do
    context 'valid create' do
      before { post 'create', params: { tracker_id: tracker_id } }

      it { expect(response).to be_successful }

      context 'response body' do
        subject(:data) { JSON.parse(response.body) }

        it { Date.parse(data['created_at']) == Date.current }
      end

      context 'new model' do
        subject(:new_tracker_record) { TrackerRecord.last }

        its(:tracker) { is_expected.to eq tracker }
      end
    end

    context 'for tracker that does not exist' do
      it 'should throw an exception' do
        expect {
          post 'create', params: { tracker_id: 'bullshit' }
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
