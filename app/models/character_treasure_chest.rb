class CharacterTreasureChest < ApplicationRecord
  belongs_to :character, class_name: "User"
  belongs_to :treasure_chest
end
