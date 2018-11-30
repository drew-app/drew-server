class Task < ApplicationRecord
  belongs_to :user

  validates_presence_of :title

  before_create :initialize_done
  before_create :initialize_started

  private

  def initialize_done
    self.done ||= false
  end

  def initialize_started
    self.started ||= false
  end
end
