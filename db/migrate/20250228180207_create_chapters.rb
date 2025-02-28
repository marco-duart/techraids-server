class CreateChapters < ActiveRecord::Migration[8.0]
  def change
    create_table :chapters do |t|
      t.string :title
      t.text :description
      t.integer :required_experience

      t.timestamps
    end
  end
end
