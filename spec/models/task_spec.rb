require 'rails_helper'

RSpec.describe Task, type: :model do

  context 'validations' do
    it { is_expected.to validate_presence_of :title }
  end

  context 'associations' do
    it { is_expected.to belong_to :user}
  end

  context 'defaults' do
    let(:user) { create :user }
    let(:default_attrs) { Hash[user: user, title: 'A title'] }

    it 'should set an unset done to false' do
      task = Task.create(default_attrs)

      expect(task.done).to be false
    end

    it 'should not override an already set done' do
      task = Task.create(default_attrs.merge(done: true))

      expect(task.done).to be true
    end

    it 'should set an unset focused to false' do
      task = Task.create(default_attrs)

      expect(task.focused).to be false
    end

    it 'should not override an already set focused' do
      task = Task.create(default_attrs.merge(focused: true))

      expect(task.focused).to be true
    end
  end

  context 'as_json' do
    let(:task) { create :task, :with_tags }

    subject(:json) { task.as_json }

    it 'should include the default attributes' do
      task.attributes.each do |key, value|
        expect(json[key]).to eq value
      end
    end

    it 'should include the tags' do
      expect(json['tags']).to contain_exactly *task.tags.as_json
    end
  end
end
