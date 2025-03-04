class ChapterPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.narrator?
        scope.all
      else
        scope.where(quest_id: user.current_chapter.quest_id)
      end
    end
  end

  def index?
    true
  end

  def show?
    user.narrator? || record.quest_id == user.current_chapter.quest_id
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
end
