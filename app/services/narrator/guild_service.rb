module Narrator
  class GuildService
    def initialize(user)
      @user = user
    end

    def guild_members
      authorize_guild_members

      guild_members = @user.managed_guild.characters

      {
        success: true,
        message: "Lista de colaboradores gerada com sucesso.",
        data: guild_members
      }
    rescue Pundit::NotAuthorizedError
      {
        success: false,
        message: "Você não tem autorização para acessar este recurso."
      }
    rescue => e
      {
        success: false,
        message: "Ocorreu um erro ao acessar esse recurso: #{e.message}"
      }
    end

    def pending_rewards
      authorize_pending_rewards

      guild = @user.managed_guild
      pending_bosses = Boss.includes(chapter: { quest: :guild }).where(chapters: { quests: { guild_id: guild.id } }, defeated: true, reward_claimed: false)
      pending_chests = CharacterTreasureChest.joins(:character, :reward)
                                             .where(users: { guild_id: guild.id }, reward_claimed: false)
                                             .select(
                                               "character_treasure_chests.*,
                                               users.name AS character_name,
                                               rewards.name AS reward_name,
                                               rewards.description AS reward_description"
                                             )

      {
        success: true,
        message: "Pendências de rewards listadas com sucesso.",
        data: {
          pending_bosses: pending_bosses,
          pending_chests: pending_chests
        }
      }
    rescue Pundit::NotAuthorizedError
      {
        success: false,
        message: "Você não tem autorização para acessar este recurso."
      }
    rescue => e
      {
        success: false,
        message: "Ocorreu um erro ao acessar esse recurso: #{e.message}"
      }
    end

    def process_reward(record, guild_id, already_claimed_msg:, success_msg:)
      record.transaction do
        authorize_deliver_reward(guild_id)

        if record.reward_claimed
          return { success: false, message: already_claimed_msg }
        end

        record.update!(reward_claimed: true)

        { success: true, message: success_msg, data: record }
      end
    end


    def deliver_reward(params)
      boss_id = params[:boss_id]
      character_treasure_chest_id = params[:character_treasure_chest_id]

      raise ArgumentError, "Parâmetro character_treasure_chest_id ou boss_id é obrigatório." if character_treasure_chest_id.nil? && boss_id.nil?

      if boss_id
        boss = Boss.includes(:guild).find_by(id: boss_id, defeated: true)
        return process_reward(
          boss,
          boss.guild.id,
          already_claimed_msg: "Recompensa já foi entregue para este Boss.",
          success_msg: "Recompensa entregue com sucesso."
        )
      end

      if character_treasure_chest_id
        character_treasure_chest = CharacterTreasureChest.includes(character: :guild).find_by(id: character_treasure_chest_id)
        process_reward(
          character_treasure_chest,
          character_treasure_chest.character.guild.id,
          already_claimed_msg: "Recompensa já foi entregue para este baú.",
          success_msg: "Recompensa entregue com sucesso."
        )
      end
    end


    private

    def authorize_guild_members
      raise Pundit::NotAuthorizedError unless NarratorPolicy.new(@user, nil).guild_members?
    end

    def authorize_pending_rewards
      raise Pundit::NotAuthorizedError unless NarratorPolicy.new(@user, nil).pending_rewards?
    end

    def authorize_deliver_reward(guild_id)
      raise Pundit::NotAuthorizedError unless NarratorPolicy.new(@user, guild_id).deliver_reward?
    end
  end
end
