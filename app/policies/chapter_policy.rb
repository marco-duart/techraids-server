class ChapterPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.narrator?
        scope.all
      else
        scope.joins(:quest).where(quests: { guild_id: user.guild_id })
      end
    end
  end

  def index?
    true
  end

  def show?
    user.narrator? || record.quest.guild_id == user.guild_id
  end

  def create?
    user.narrator?
  end

  def update?
    user.narrator?
  end

  def destroy?
    user.narrator?
  end

  def progress?
    return false unless user.character?

    user.current_chapter.quest.guild_id == user.guild_id
  end
end
