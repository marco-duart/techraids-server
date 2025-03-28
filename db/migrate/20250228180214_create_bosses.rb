class CreateBosses < ActiveRecord::Migration[8.0]
  def change
    create_table :bosses do |t|
      t.string :name, null: false
      t.string :slogan
      t.text :description
      t.integer :required_experience, null: false

      t.timestamps
    end
  end
end
