class CreateVillages < ActiveRecord::Migration[8.0]
  def change
    create_table :villages do |t|
      t.string :name, null: false
      t.text :description
      t.integer :village_type, null: false
      t.boolean :active, default: true

      t.timestamps
    end
  end
end
