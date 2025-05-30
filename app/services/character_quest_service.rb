class CharacterQuestService
  include Rails.application.routes.url_helpers

  def initialize(user)
    @user = user
  end

  def fetch_quest_and_companions
    return { success: false, error: "Personagem não pertence a nenhuma guild!" } if @user.guild.nil?

    guild = @user.guild
    quest = guild.quest
    chapters = fetch_chapters_with_bosses(quest.chapters.includes(boss: { finishing_character: :character_class }))
    current_chapter = @user.current_chapter
    current_boss = current_chapter.boss
    guild_members = fetch_guild_members(guild)

    boss_data = current_boss&.as_json&.merge(
                  team_can_defeat: current_boss.team_can_defeat?,
                  is_finishing_hero: current_boss.finishing_hero?(@user)
                )

    {
      success: true,
      data: {
        quest: quest,
        chapters: chapters,
        current_chapter: current_chapter,
        current_boss: boss_data,
        guild_members: guild_members,
        last_task: fetch_last_task,
        last_mission: fetch_last_mission
      }
    }
  end

  private

  def fetch_chapters_with_bosses(chapters)
    chapters.ordered.map do |chapter|
      chapter_data = chapter.as_json

      if chapter.boss.present?
        boss = chapter.boss
        boss_data = boss.as_json

        if boss.finishing_character.present?
          finishing = boss.finishing_character
          boss_data[:finishing_character] = {
            id: finishing.id,
            nickname: finishing.nickname,
            image_url: finishing.character_class.image.attached? ? rails_blob_url(finishing.character_class.image) : nil
          }
        end

        chapter_data[:boss] = boss_data
      end

      chapter_data
    end
  end

  def fetch_guild_members(guild)
    guild.characters.where.not(id: @user.id).select(:id, :nickname, :experience, :character_class_id, :current_chapter_id, :active_title_id).map do |member|
      {
        id: member.id,
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
    @user.character_tasks.last_pending || @user.tasks.last
  end

  def fetch_last_mission
    @user.character_missions.last_pending || @user.missions.last
  end
end
