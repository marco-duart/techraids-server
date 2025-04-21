class CreateGuildNotices < ActiveRecord::Migration[7.0]
  def change
    create_table :guild_notices do |t|
      t.string :title
      t.text :content
      t.integer :priority
      t.boolean :active, default: true

      t.timestamps
    end
  end
end
