class Tracker < ApplicationRecord
  belongs_to :user
  has_many :tracker_records, dependent: :destroy

  validates_presence_of :title

  def as_json *args
    super(*args).merge('tracker_records' => tracker_records.as_json)
  end
end
