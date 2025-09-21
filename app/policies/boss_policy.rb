class BossPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      return scope.none unless user.narrator?

      if user.managed_guild.present?
        scope.joins(chapter: :quest)
             .where(quests: { guild_id: user.managed_guild.id })
      else
        scope.none
      end
    end
  end

  def index?
    user.narrator?
  end

  def show?
    user.narrator? && boss_belongs_to_managed_guild?
  end

  def create?
    user.narrator? && user.managed_guild.present?
  end

  def update?
    user.narrator? && boss_belongs_to_managed_guild?
  end

  def destroy?
    user.narrator? && boss_belongs_to_managed_guild?
  end

  private

  def boss_belongs_to_managed_guild?
    return false unless user.managed_guild.present?

    record.chapter.quest.guild_id == user.managed_guild.id
  end
end
