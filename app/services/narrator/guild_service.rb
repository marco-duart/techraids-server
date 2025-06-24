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
      pending_bosses = guild.quest.chapters.joins(:bosses)
                           .where(bosses: { defeated: true, reward_claimed: false })
      pending_chests = CharacterTreasureChest.joins(:character)
                                             .where(characters: { guild_id: guild.id }, reward_claimed: false)

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

    private

    def authorize_guild_members
      raise Pundit::NotAuthorizedError unless NarratorPolicy.new(@user, nil).guild_members?
    end

    def authorize_pending_rewards
      raise Pundit::NotAuthorizedError unless NarratorPolicy.new(@user, nil).pending_rewards?
    end
  end
end
