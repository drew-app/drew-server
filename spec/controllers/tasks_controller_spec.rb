require 'rails_helper'

RSpec.describe TasksController, type: :controller do
  describe '#index' do
    let!(:tasks) { [] }

    before { get 'index' }

    subject(:data) { JSON.parse(response.body) }

    context 'with no tasks' do
      it { expect(response).to be_successful }
      it { expect(data).to eq [] }
    end

    context 'with some tasks' do
      let!(:tasks) { create_list :task, 3 }

      it { expect(response).to be_successful }
      it { expect(data.length).to eq 3 }

      context 'task attributes' do
        let(:source_titles) { tasks.collect(&:title) }

        subject(:respone_titles) { data.map { |t| t['title'] } }

        it { expect(respone_titles).to contain_exactly(*source_titles) }
      end
    end
  end
end
