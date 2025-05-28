class Chapter < ApplicationRecord
  belongs_to :quest
  has_many :tasks
  has_many :missions
  has_one :boss

  validates :position, presence: true
  validates :position, uniqueness: { scope: :quest_id }

  scope :ordered, -> { order(:position) }
end
