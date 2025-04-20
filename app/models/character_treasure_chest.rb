class CharacterTreasureChest < ApplicationRecord
  belongs_to :character, class_name: "User"
  belongs_to :treasure_chest
  belongs_to :reward
end
