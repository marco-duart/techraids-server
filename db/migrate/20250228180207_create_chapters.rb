class CreateChapters < ActiveRecord::Migration[8.0]
  def change
    create_table :chapters do |t|
      t.string :title, null: false
      t.text :description
      t.integer :required_experience, null: false
      t.integer :position_x
      t.integer :position_y

      t.timestamps
    end
  end
end
