class CreateCharacterClasses < ActiveRecord::Migration[8.0]
  def change
    create_table :character_classes do |t|
      t.string :name, null: false
      t.string :slogan
      t.integer :required_experience, default: 0
      t.float :entry_fee, default: 0

      t.timestamps
    end
  end
end
