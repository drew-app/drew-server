require 'rails_helper'

RSpec.describe 'TasksController routing', type: :routing do
  it { expect(get('/api/tasks')).to route_to(controller: 'tasks', action: 'index') }
  it { expect(post('/api/tasks')).to route_to(controller: 'tasks', action: 'create') }
  it { expect(put('/api/tasks/1')).to route_to(controller: 'tasks', action: 'update', id: '1') }
  it { expect(get('/api/tasks/1')).to route_to(controller: 'tasks', action: 'show', id: '1') }
  it { expect(delete('/api/tasks/1')).to_not be_routable }
end

RSpec.describe TasksController, type: :controller do
  let(:user) { create :user }
  let(:other_user) { create :user }

  before do
    sign_in_user user
  end

  describe '#index' do
    let!(:tasks) { [] }

    before { get 'index' }

    subject(:data) { JSON.parse(response.body) }

    context 'with no tasks' do
      it { expect(response).to be_successful }
      it { expect(data).to eq [] }
    end

    context 'with some tasks' do
      let!(:tasks) { create_list :task, 3, user: user }

      it { expect(response).to be_successful }
      it { expect(data.length).to eq 3 }

      context 'task attributes' do
        let(:source_titles) { tasks.collect(&:title) }

        subject(:response_titles) { data.map { |t| t['title'] } }

        it { expect(response_titles).to contain_exactly(*source_titles) }
      end
    end

    context 'with tasks from another user' do
      let!(:tasks) { create_list :task, 3, user: other_user }

      it { expect(response).to be_successful }
      it { expect(data).to eq [] }
    end


  end

  describe '#show' do
    context 'with no task' do
      it 'should throw an exception' do
        expect { get('show', params: { id: 1 }) }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'with task' do
      let!(:task) { create :task, user: user }

      before { get('show', params: { id: task.id }) }

      subject(:data) { JSON.parse(response.body) }

      it { expect(response).to be_successful }
      it { expect(data['title']).to eq task.title }
    end

    context 'with other user\'s task' do
      let!(:task) { create :task, user: other_user }

      it 'should throw an exception' do
        expect { get('show', params: { id: task.id }) }.to raise_error(ActiveRecord::RecordNotFound)
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
      end

      context 'new model' do
        subject(:new_task) { Task.last }

        its(:title) { is_expected.to eq task_params[:title] }
        its(:user) { is_expected.to eq user }
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

    context 'with tags' do
      let(:task_params) { attributes_for :task }
      let(:tag_names) { %w(home phone urgent) }
      let!(:pre_existing_tags) { [create(:tag, name: 'home', user: user), create(:tag, name: 'phone', user: user)] }

      before { post 'create', params: { task: task_params, tags: tag_names } }

      it 'should create the new tag' do
        expect(Tag.exists?(user: user, name: 'urgent')).to be true
      end

      it 'should not recreate already existing tags' do
        expect(user.tags.count).to eq 3 #As opposed to 5
      end

      it 'should assign the task to each of the tags' do
        user.tags.where(name: tag_names).each do |tag|
          expect(tag.tasks.first.title).to eq task_params[:title]
        end
      end

      it 'should assign each of the tags to the task' do
        expect(user.tasks.first.tags.pluck(:name)).to contain_exactly(*tag_names)
      end

      context 'with different case' do
        let(:tag_names) { %w(Home Phone UrGeNt) }

        it 'should create the new tag' do
          expect(Tag.exists?(user: user, name: 'UrGeNt')).to be true
        end

        it 'should not recreate already existing tags' do
          expect(user.tags.count).to eq 3 #As opposed to 5
        end
      end
    end
  end

  describe '#update' do
    context 'valid update' do
      let(:existing_task) { create :task, user: user }

      context 'uri response' do
        let(:update_params) { Hash[done: true] }

        before { put 'update', params: { task: update_params, id: existing_task.id } }

        it { expect(response).to be_successful }
      end

      context 'allowed params' do
        shared_examples_for :update_params do |param_key, new_value|
          let(:update_params) { Hash[param_key => new_value] }

          # noinspection RubyArgCount
          subject(:data) { JSON.parse(response.body) }
          # noinspection RubyArgCount
          subject(:updated_model) { Task.find(existing_task.id) }

          before { put 'update', params: { task: update_params, id: existing_task.id } }

          it("should update in the response for #{param_key}") { expect(data[param_key.to_s]).to eq new_value }
          it("should update the model for #{param_key}") { expect(updated_model.send(param_key)).to eq new_value }
        end

        it_behaves_like :update_params, :title, 'The new title'
        it_behaves_like :update_params, :done, true
        it_behaves_like :update_params, :started, true
        it_behaves_like :update_params, :description, 'The new description'
      end

      context 'with tags' do
        let(:update_params) { Hash[done: true] }
        let(:tag_names) { %w(home phone urgent) }
        let!(:pre_existing_tags) { [create(:tag, name: 'home', user: user), create(:tag, name: 'phone', user: user)] }

        before { put 'update', params: { task: update_params, id: existing_task.id, tags: tag_names } }

        it 'should create the new tag' do
          expect(Tag.exists?(user: user, name: 'urgent')).to be true
        end

        it 'should not recreate already existing tags' do
          expect(user.tags.count).to eq 3 #As opposed to 5
        end

        it 'should assign the task to each of the tags' do
          user.tags.where(name: tag_names).each do |tag|
            expect(tag.tasks.first).to eq existing_task.reload
          end
        end

        it 'should assign each of the tags to the task' do
          expect(existing_task.reload.tags.pluck(:name)).to contain_exactly(*tag_names)
        end
      end

      context 'with pre-existing tags' do
        let(:tags) { create_list :tag, 3 }
        let(:existing_task) { create :task, user: user, done: false, tags: tags }
        let(:update_params) { Hash[done: true] }

        subject(:data) { JSON.parse(response.body) }
        subject(:updated_model) { Task.find(existing_task.id) }

        before { put 'update', params: { task: update_params, id: existing_task.id } }

        it { expect(data['done']).to eq true }
        it { expect(updated_model.done).to eq true }
        it { expect(updated_model.tags).to contain_exactly(*tags) }
      end
    end

    context 'update with invalid attributes' do
      let(:existing_task) { create :task, user: user }

      it 'should raise an error' do
        expect {
          put 'update', params: { task: {title: ''}, id: existing_task.id
        } }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end

    context 'task belongs to another user' do
      let(:existing_task) { create :task, user: other_user }

      it 'should raise an error' do
        expect {
          put 'update', params: { task: {title: 'Another title'}, id: existing_task.id
        } }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
