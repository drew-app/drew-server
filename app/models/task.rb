class Task < ApplicationRecord
  validates_presence_of :title

  before_create :initialize_done

  private

  def initialize_done
    self.done ||= false
  end
end
