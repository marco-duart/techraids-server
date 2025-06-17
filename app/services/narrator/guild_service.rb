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

    private

    def authorize_guild_members
      raise Pundit::NotAuthorizedError unless NarratorPolicy.new(@user, nil).guild_members?
    end
  end
end
