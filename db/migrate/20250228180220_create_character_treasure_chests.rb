class CreateCharacterTreasureChests < ActiveRecord::Migration[8.0]
  def change
    create_table :character_treasure_chests do |t|
      t.integer :amount

      t.timestamps
    end
  end
end
