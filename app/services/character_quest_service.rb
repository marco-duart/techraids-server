class CharacterQuestService
  include Rails.application.routes.url_helpers

  def initialize(user)
    @user = user
  end

  def fetch_quest_and_companions
    guild = @user.guild

    if guild.nil?
      return { success: false, error: "Personagem não pertence a nenhuma guild!" }
    end

    quest = guild.quest
    current_chapter = @user.current_chapter

    guild_members = guild.characters.where.not(id: @user.id).select(:nickname, :experience, :character_class_id, :current_chapter_id, :active_title_id)

    guild_members_with_details = guild_members.map do |member|
      image_url = member.character_class.image.attached? ? rails_blob_url(member.character_class.image) : nil
      {
        nickname: member.nickname,
        current_level: member.current_level,
        experience: member.experience,
        character_class: {
          name: member.character_class.name,
          slogan: member.character_class.slogan,
          image_url: image_url
        },
        current_chapter: member.current_chapter,
        active_title: member.active_title
      }
    end

    {
      success: true,
      data: {
        quest: quest,
        current_chapter: current_chapter,
        guild_members: guild_members_with_details
      }
    }
  end
end
