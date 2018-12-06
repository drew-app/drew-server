class Tag < ApplicationRecord
  belongs_to :user

  has_and_belongs_to_many :tasks

  validates_uniqueness_of :name, scope: :user_id, case_sensitive: false
end
