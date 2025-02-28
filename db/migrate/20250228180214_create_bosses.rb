class CreateBosses < ActiveRecord::Migration[8.0]
  def change
    create_table :bosses do |t|
      t.string :name
      t.string :slogan
      t.text :description
      t.integer :required_experience

      t.timestamps
    end
  end
end
