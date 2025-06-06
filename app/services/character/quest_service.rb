module Character
  class QuestService
    include Rails.application.routes.url_helpers

    def initialize(user)
      @user = user
      @guild = user.guild
    end

    def fetch_quest_and_companions
      return { success: false, error: "Personagem não pertence a nenhuma guild!" } if @guild.nil?

      quest = @guild.quest
      chapters = quest.chapters
                    .includes(boss: { finishing_character: :character_class })
                    .ordered

      guild_members = @guild.characters
                            .includes(:character_class, :current_chapter, :active_title)
                            .where.not(id: @user.id)
                            .group_by(&:current_chapter_id)

      processed_chapters = chapters.map do |chapter|
        process_chapter(chapter, guild_members[chapter.id] || [])
      end

      {
        success: true,
        data: {
          quest: quest,
          chapters: processed_chapters,
          last_task: fetch_last_task,
          last_mission: fetch_last_mission
        }
      }
    end

    private

    def process_chapter(chapter, chapter_members)
      is_hero_chapter = chapter == @user.current_chapter

      {
        **chapter.as_json,
        is_hero_chapter: is_hero_chapter,
        character: is_hero_chapter ? format_character_data(@user) : nil,
        guild_members: chapter_members.any? ? chapter_members.map { |m| format_character_data(m) } : nil,
        boss: process_boss(chapter.boss, is_hero_chapter)
      }
    end

    def process_boss(boss, is_hero_chapter)
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
        team_can_defeat: boss.team_can_defeat?,
        is_finishing_hero: is_hero_chapter ? boss.finishing_hero?(@user) : nil
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
          name: character_class.name,
          slogan: character_class.slogan,
          image_url: character_class.image.attached? ? rails_blob_url(character_class.image) : nil
        },
        current_chapter: character.current_chapter,
        active_title: character.active_title
      }
    end

    def fetch_last_task
      @last_task ||= @user.character_tasks.last_pending || @user.tasks.last
    end

    def fetch_last_mission
      @last_mission ||= @user.character_missions.last_pending || @user.missions.last
    end
  end
end
