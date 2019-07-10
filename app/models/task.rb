class Task < ApplicationRecord
  belongs_to :user

  has_and_belongs_to_many :tags

  validates_presence_of :title

  def as_json *args
    super(*args).merge('tags' => tags.as_json)
  end
end
