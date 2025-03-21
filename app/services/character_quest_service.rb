class CharacterQuestService
  include Rails.application.routes.url_helpers

  def initialize(character)
    @character = character
  end

  def fetch_quest_and_companions
    return { success: false, error: "Personagem não pertence a nenhuma guild!" } if @character.guild.nil?

    guild = @character.guild
    quest = guild.quest
    chapters = quest.chapters
    current_chapter = @character.current_chapter
    guild_members = fetch_guild_members(guild)

    {
      success: true,
      data: {
        quest: quest,
        chapters: chapters,
        current_chapter: current_chapter,
        guild_members: guild_members,
        last_task: fetch_last_task,
        last_mission: fetch_last_mission
      }
    }
  end

  private

  def fetch_guild_members(guild)
    guild.characters.where.not(id: @character.id).select(:nickname, :experience, :character_class_id, :current_chapter_id, :active_title_id).map do |member|
      {
        nickname: member.nickname,
        current_level: member.current_level,
        experience: member.experience,
        character_class: {
          name: member.character_class.name,
          slogan: member.character_class.slogan,
          image_url: member.character_class.image.attached? ? rails_blob_url(member.character_class.image) : nil
        },
        current_chapter: member.current_chapter,
        active_title: member.active_title
      }
    end
  end

  def fetch_last_task
    @character.character_tasks.last_pending || @character.tasks.last
  end

  def fetch_last_mission
    @character.character_missions.last_pending || @character.missions.last
  end
end
