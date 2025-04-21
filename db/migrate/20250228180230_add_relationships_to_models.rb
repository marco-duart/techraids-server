class AddRelationshipsToModels < ActiveRecord::Migration[7.0]
  def change
    add_reference :guilds, :village, foreign_key: true
    add_reference :guilds, :narrator, foreign_key: { to_table: :users }
    add_reference :users, :village, foreign_key: true
    add_reference :users, :guild, foreign_key: true
    add_reference :users, :character_class, foreign_key: true
    add_reference :users, :specialization, foreign_key: true
    add_reference :users, :current_chapter, foreign_key: { to_table: :chapters }
    add_reference :users, :active_title, foreign_key: { to_table: :honorary_titles }
    add_reference :specializations, :guild, foreign_key: true
    add_reference :character_classes, :specialization, foreign_key: true
    add_reference :tasks, :character, foreign_key: { to_table: :users }
    add_reference :tasks, :narrator, foreign_key: { to_table: :users }
    add_reference :missions, :character, foreign_key: { to_table: :users }
    add_reference :missions, :narrator, foreign_key: { to_table: :users }
    add_reference :treasure_chests, :guild, foreign_key: true
    add_reference :rewards, :treasure_chest, foreign_key: true
    add_reference :character_treasure_chests, :character, foreign_key: { to_table: :users }
    add_reference :character_treasure_chests, :treasure_chest, foreign_key: true
    add_reference :character_treasure_chests, :reward, foreign_key: true
    add_reference :honorary_titles, :character, foreign_key: { to_table: :users }
    add_reference :honorary_titles, :narrator, foreign_key: { to_table: :users }
    add_reference :quests, :guild, foreign_key: true
    add_reference :chapters, :quest, foreign_key: true
    add_reference :bosses, :chapter, foreign_key: true
    add_reference :guild_notices, :author, foreign_key: { to_table: :users }
    add_reference :guild_notices, :guild, foreign_key: true
    add_reference :arcane_announcements, :author, foreign_key: { to_table: :users }
    add_reference :arcane_announcements, :village, foreign_key: true
  end
end
