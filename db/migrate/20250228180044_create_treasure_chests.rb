class CreateTreasureChests < ActiveRecord::Migration[8.0]
  def change
    create_table :treasure_chests do |t|
      t.string :title
      t.float :value

      t.timestamps
    end
  end
end
