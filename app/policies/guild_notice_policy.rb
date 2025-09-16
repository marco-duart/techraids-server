class GuildNoticePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.narrator? && user.managed_guild.present?
        scope.where(guild_id: user.managed_guild.id)
      elsif user.character?
        scope.where(guild_id: user.guild_id).active
      else
        scope.none
      end
    end
  end

  def create?
    user.narrator? && user.managed_guild.present?
  end

  def update?
    user.narrator? && (record.author == user)
  end

  def destroy?
    update?
  end
end
