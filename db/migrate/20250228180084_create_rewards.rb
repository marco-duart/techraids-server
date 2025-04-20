class CreateRewards < ActiveRecord::Migration[8.0]
  def change
    create_table :rewards do |t|
      t.string :name
      t.text :description
      t.integer :reward_type
      t.boolean :is_limited
      t.integer :stock_quantity

      t.timestamps
    end
  end
end
