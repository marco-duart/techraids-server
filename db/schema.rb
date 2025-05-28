# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_02_28_184900) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "arcane_announcements", force: :cascade do |t|
    t.string "title"
    t.text "content"
    t.integer "announcement_type"
    t.integer "priority"
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "author_id"
    t.bigint "village_id"
    t.index ["author_id"], name: "index_arcane_announcements_on_author_id"
    t.index ["village_id"], name: "index_arcane_announcements_on_village_id"
  end

  create_table "bosses", force: :cascade do |t|
    t.string "name", null: false
    t.string "slogan"
    t.text "description"
    t.boolean "defeated", default: false
    t.boolean "reward_claimed", default: false
    t.string "reward_description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "chapter_id"
    t.bigint "finishing_character_id"
    t.index ["chapter_id"], name: "index_bosses_on_chapter_id"
    t.index ["finishing_character_id"], name: "index_bosses_on_finishing_character_id"
  end

  create_table "chapters", force: :cascade do |t|
    t.string "title", null: false
    t.text "description"
    t.integer "required_experience", null: false
    t.integer "position_x"
    t.integer "position_y"
    t.decimal "position", precision: 10, scale: 2, default: "0.0", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "quest_id"
    t.index ["quest_id", "position"], name: "index_chapters_on_quest_id_and_position", unique: true
    t.index ["quest_id"], name: "index_chapters_on_quest_id"
  end

  create_table "character_classes", force: :cascade do |t|
    t.string "name", null: false
    t.string "slogan"
    t.integer "required_experience", default: 0
    t.integer "entry_fee", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "specialization_id"
    t.index ["specialization_id"], name: "index_character_classes_on_specialization_id"
  end

  create_table "character_treasure_chests", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "character_id"
    t.bigint "treasure_chest_id"
    t.bigint "reward_id"
    t.index ["character_id"], name: "index_character_treasure_chests_on_character_id"
    t.index ["reward_id"], name: "index_character_treasure_chests_on_reward_id"
    t.index ["treasure_chest_id"], name: "index_character_treasure_chests_on_treasure_chest_id"
  end

  create_table "guild_notices", force: :cascade do |t|
    t.string "title"
    t.text "content"
    t.integer "priority"
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "author_id"
    t.bigint "guild_id"
    t.index ["author_id"], name: "index_guild_notices_on_author_id"
    t.index ["guild_id"], name: "index_guild_notices_on_guild_id"
  end

  create_table "guilds", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "village_id"
    t.bigint "narrator_id"
    t.index ["narrator_id"], name: "index_guilds_on_narrator_id"
    t.index ["village_id"], name: "index_guilds_on_village_id"
  end

  create_table "honorary_titles", force: :cascade do |t|
    t.string "title", null: false
    t.string "slogan"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "character_id"
    t.bigint "narrator_id"
    t.index ["character_id"], name: "index_honorary_titles_on_character_id"
    t.index ["narrator_id"], name: "index_honorary_titles_on_narrator_id"
  end

  create_table "missions", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.integer "status", default: 0
    t.integer "gold_reward"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "character_id"
    t.bigint "narrator_id"
    t.index ["character_id"], name: "index_missions_on_character_id"
    t.index ["narrator_id"], name: "index_missions_on_narrator_id"
  end

  create_table "quests", force: :cascade do |t|
    t.string "title", null: false
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "guild_id"
    t.index ["guild_id"], name: "index_quests_on_guild_id"
  end

  create_table "rewards", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.integer "reward_type"
    t.boolean "is_limited"
    t.integer "stock_quantity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "treasure_chest_id"
    t.index ["treasure_chest_id"], name: "index_rewards_on_treasure_chest_id"
  end

  create_table "specializations", force: :cascade do |t|
    t.string "title", null: false
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "guild_id"
    t.index ["guild_id"], name: "index_specializations_on_guild_id"
  end

  create_table "tasks", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.integer "status", default: 0
    t.integer "experience_reward"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "character_id"
    t.bigint "narrator_id"
    t.index ["character_id"], name: "index_tasks_on_character_id"
    t.index ["narrator_id"], name: "index_tasks_on_narrator_id"
  end

  create_table "treasure_chests", force: :cascade do |t|
    t.string "title", null: false
    t.integer "value", null: false
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "guild_id"
    t.index ["guild_id"], name: "index_treasure_chests_on_guild_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "provider", default: "email", null: false
    t.string "uid", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.boolean "allow_password_change", default: false
    t.datetime "remember_created_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.string "name"
    t.string "nickname"
    t.string "email"
    t.integer "role", default: 0
    t.integer "experience", default: 0
    t.integer "gold", default: 0
    t.json "tokens"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "village_id"
    t.bigint "guild_id"
    t.bigint "character_class_id"
    t.bigint "specialization_id"
    t.bigint "current_chapter_id"
    t.bigint "active_title_id"
    t.index ["active_title_id"], name: "index_users_on_active_title_id"
    t.index ["character_class_id"], name: "index_users_on_character_class_id"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["current_chapter_id"], name: "index_users_on_current_chapter_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["guild_id"], name: "index_users_on_guild_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["specialization_id"], name: "index_users_on_specialization_id"
    t.index ["uid", "provider"], name: "index_users_on_uid_and_provider", unique: true
    t.index ["village_id"], name: "index_users_on_village_id"
  end

  create_table "villages", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.integer "village_type", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "arcane_announcements", "users", column: "author_id"
  add_foreign_key "arcane_announcements", "villages"
  add_foreign_key "bosses", "chapters"
  add_foreign_key "bosses", "users", column: "finishing_character_id"
  add_foreign_key "chapters", "quests"
  add_foreign_key "character_classes", "specializations"
  add_foreign_key "character_treasure_chests", "rewards"
  add_foreign_key "character_treasure_chests", "treasure_chests"
  add_foreign_key "character_treasure_chests", "users", column: "character_id"
  add_foreign_key "guild_notices", "guilds"
  add_foreign_key "guild_notices", "users", column: "author_id"
  add_foreign_key "guilds", "users", column: "narrator_id"
  add_foreign_key "guilds", "villages"
  add_foreign_key "honorary_titles", "users", column: "character_id"
  add_foreign_key "honorary_titles", "users", column: "narrator_id"
  add_foreign_key "missions", "users", column: "character_id"
  add_foreign_key "missions", "users", column: "narrator_id"
  add_foreign_key "quests", "guilds"
  add_foreign_key "rewards", "treasure_chests"
  add_foreign_key "specializations", "guilds"
  add_foreign_key "tasks", "users", column: "character_id"
  add_foreign_key "tasks", "users", column: "narrator_id"
  add_foreign_key "treasure_chests", "guilds"
  add_foreign_key "users", "chapters", column: "current_chapter_id"
  add_foreign_key "users", "character_classes"
  add_foreign_key "users", "guilds"
  add_foreign_key "users", "honorary_titles", column: "active_title_id"
  add_foreign_key "users", "specializations"
  add_foreign_key "users", "villages"
end
