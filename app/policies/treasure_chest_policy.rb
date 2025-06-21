class TreasureChestPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.narrator?
        scope.where(guild_id: user.managed_guild.id)
      else
        scope.none
      end
    end
  end

  def index?
    user.narrator? && record.guild_id == user.managed_guild.id
  end

  def show?
    index?
  end

  def create?
    user.narrator?
  end

  def activate?
    index?
  end

  def deactivate?
    index?
  end
end
