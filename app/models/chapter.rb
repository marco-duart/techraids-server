class Chapter < ApplicationRecord
  belongs_to :quest
  has_many :tasks
  has_many :missions
  has_one :boss
end
