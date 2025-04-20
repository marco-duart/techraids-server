class TreasureChest < ApplicationRecord
  belongs_to :guild
  has_many :rewards
  has_many :character_treasure_chests
  has_many :characters, through: :character_treasure_chests, source: :character

  scope :active, -> { where(active: true) }
  scope :with_available_rewards, -> {
    joins(:rewards).merge(Reward.available).distinct
  }
end
