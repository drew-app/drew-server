class User < ApplicationRecord
  has_many :tasks
  has_many :tags
  has_many :trackers
end
