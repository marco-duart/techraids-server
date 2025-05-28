class CreateBosses < ActiveRecord::Migration[8.0]
  def change
    create_table :bosses do |t|
      t.string :name, null: false
      t.string :slogan
      t.text :description
      t.boolean :defeated, default: false
      t.boolean :reward_claimed, default: false
      t.string :reward_description

      t.timestamps
    end
  end
end
