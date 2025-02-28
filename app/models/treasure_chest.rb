class TreasureChest < ApplicationRecord
  has_many :character_treasure_chests
  has_many :characters, through: :character_treasure_chests, source: :character
end
