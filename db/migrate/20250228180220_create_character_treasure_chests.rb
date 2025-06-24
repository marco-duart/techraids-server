class CreateCharacterTreasureChests < ActiveRecord::Migration[8.0]
  def change
    create_table :character_treasure_chests do |t|
      t.boolean :reward_claimed, default: false
      t.timestamps
    end
  end
end
