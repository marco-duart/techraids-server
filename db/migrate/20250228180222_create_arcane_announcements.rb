class CreateArcaneAnnouncements < ActiveRecord::Migration[7.0]
  def change
    create_table :arcane_announcements do |t|
      t.string :title
      t.text :content
      t.integer :announcement_type
      t.integer :priority
      t.boolean :active, default: true

      t.timestamps
    end
  end
end
