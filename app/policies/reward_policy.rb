class RewardPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.narrator?
        scope.joins(:treasure_chest).where(treasure_chests: { guild_id: user.managed_guild.id })
      else
        scope.none
      end
    end
  end

  def index?
    user.narrator? && record.treasure_chest.guild_id == user.managed_guild.id
  end

  def show?
    index?
  end

  def create?
    user.narrator? && TreasureChest.find(record.treasure_chest_id).guild_id == user.managed_guild.id
  end

  def restock?
    index?
  end

  def remove_stock?
    index?
  end
end
