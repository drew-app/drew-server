require 'rails_helper'

RSpec.describe Task, type: :model do

  context 'validations' do
    it { is_expected.to validate_presence_of :title }
  end

  context 'defaults' do
    it 'should set an unset done to false' do
      task = Task.new(title: 'A title')
      task.save
      expect(task.done).to be false
    end

    it 'should not override an already set done' do
      task = Task.new(title: 'A title', done: true)
      task.save
      expect(task.done).to be true
    end

    it 'should set an unset started to false' do
      task = Task.new(title: 'A title')
      task.save
      expect(task.started).to be false
    end

    it 'should not override and already set started' do
      task = Task.new(title: 'A title', started: true)
      task.save
      expect(task.started).to be true
    end
  end
end
