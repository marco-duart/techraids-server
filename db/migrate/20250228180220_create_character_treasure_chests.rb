class CreateCharacterTreasureChests < ActiveRecord::Migration[8.0]
  def change
    create_table :character_treasure_chests do |t|
      t.timestamps
    end
  end
end
