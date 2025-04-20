class CreateMissions < ActiveRecord::Migration[8.0]
  def change
    create_table :missions do |t|
      t.string :title
      t.text :description
      t.integer :status, default: 0
      t.integer :gold_reward

      t.timestamps
    end
  end
end
