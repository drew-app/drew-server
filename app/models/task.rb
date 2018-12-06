class Task < ApplicationRecord
  belongs_to :user

  has_and_belongs_to_many :tags

  validates_presence_of :title

  before_create :initialize_done
  before_create :initialize_started

  def as_json *args
    super(*args).merge('tags' => tags.as_json)
  end

  private

  def initialize_done
    self.done ||= false
  end

  def initialize_started
    self.started ||= false
  end
end
