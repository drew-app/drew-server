require 'rails_helper'

RSpec.describe 'TasksController routing', type: :routing do
  def should_not_route route
    expect(route).to_not be_routable
  end

  it { expect( get('/api/tasks')).to route_to(controller: 'tasks', action: 'index') }
  it { expect( post('/api/tasks')).to route_to(controller: 'tasks', action: 'create') }
  it { expect( put('/api/tasks/1')).to route_to(controller: 'tasks', action: 'update', id: '1')}
  it { should_not_route get('/api/tasks/1') }
  it { should_not_route delete('/api/tasks/1') }
end

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

  describe '#create' do
    context 'valid create' do
      before { post 'create', params: { task: task_params } }

      let(:task_params) { attributes_for :task }

      it { expect(response).to be_successful }

      context 'response body' do
        subject(:data) { JSON.parse(response.body) }

        its(['title']) { is_expected.to eq task_params[:title] }
        its(['done']) { is_expected.to be false }
      end

      context 'new model' do
        subject(:new_task) { Task.last }

        its(:title) { is_expected.to eq task_params[:title] }
        its(:done) { is_expected.to eq false }
      end
    end

    context 'invalid attributes' do
      let(:task_params) { attributes_for :task, title: '' }

      it 'should raise a validation error' do
        expect {
          post 'create', params: { task: task_params }
        }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end

  describe '#update' do
    context 'valid update' do
      let(:existing_task) { create :task }

      let(:update_params) { Hash[ done: true ] }

      before { put 'update', params: { task: update_params, id: existing_task.id } }

      it { expect(response).to be_successful }

      context 'response body' do
        subject(:data) { JSON.parse(response.body) }

        context 'unchanged attributes' do
          its(['title']) { is_expected.to eq existing_task.title }
        end

        context 'changed attributes' do
          its(['done']) { is_expected.to eq update_params[:done] }
        end
      end

      context 'updated model' do
        subject(:updated_model) { Task.find(existing_task.id) }

        context 'unchanged attributes' do
          its(:title) { is_expected.to eq existing_task.title }
        end

        context 'changed attributes' do
          its(:done) { is_expected.to eq update_params[:done] }
        end
      end
    end
  end
end
