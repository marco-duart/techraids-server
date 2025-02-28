class CreateCharacterClasses < ActiveRecord::Migration[8.0]
  def change
    create_table :character_classes do |t|
      t.string :name
      t.string :slogan
      t.integer :required_experience

      t.timestamps
    end
  end
end
