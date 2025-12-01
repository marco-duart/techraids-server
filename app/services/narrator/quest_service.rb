module Narrator
  class QuestService
    include Rails.application.routes.url_helpers

    def initialize(user)
      @user = user
      @guild = user.managed_guild
    end

    def fetch_quest_and_companions
      return { success: false, error: "Narrador não gerencia nenhuma guild!" } if @guild.nil?

      quest = @guild.quest
      chapters = quest.chapters
                    .includes(boss: { finishing_character: :character_class })
                    .ordered

      guild_members = @guild.characters
                            .includes(:character_class, :current_chapter, :active_title)
                            .group_by(&:current_chapter_id)

      processed_chapters = chapters.map do |chapter|
        process_chapter(chapter, guild_members[chapter.id] || [])
      end

      {
        success: true,
        data: {
          quest: quest,
          chapters: processed_chapters
        }
      }
    end

    private

    def process_chapter(chapter, chapter_members)
      {
        **chapter.as_json,
        guild_members: chapter_members.any? ? chapter_members.map { |m| format_character_data(m) } : nil,
        boss: process_boss(chapter.boss)
      }
    end

    def process_boss(boss)
      return nil unless boss

      finishing_character = boss.finishing_character
      finishing_data = if finishing_character&.character_class
        {
          id: finishing_character.id,
          nickname: finishing_character.nickname,
          image_url: finishing_character.character_class.image.attached? ?
                    rails_blob_url(finishing_character.character_class.image) : nil
        }
      end

      {
        **boss.as_json,
        finishing_character: finishing_data,
        team_can_defeat: boss.team_can_defeat?
      }
    end

    def format_character_data(character)
      character_class = character.character_class
      {
        id: character.id,
        nickname: character.nickname,
        current_level: character.current_level,
        experience: character.experience,
        character_class: {
          name: character_class&.name || "Não selecionada",
          slogan: character_class&.slogan || "",
          image_url: character_class&.image&.attached? ? rails_blob_url(character_class.image) : nil
        },
        current_chapter: character.current_chapter,
        active_title: character.active_title
      }
    end
  end
end
