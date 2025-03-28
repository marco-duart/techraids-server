class CreateTreasureChests < ActiveRecord::Migration[8.0]
  def change
    create_table :treasure_chests do |t|
      t.string :title, null: false
      t.float :value, null: false

      t.timestamps
    end
  end
end
