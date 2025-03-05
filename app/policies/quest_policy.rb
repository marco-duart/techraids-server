class QuestPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.narrator?
        scope.all
      else
        scope.joins(:chapters).where(chapters: { id: user.current_chapter_id }).distinct
      end
    end
  end

  def index?
    true
  end

  def show?
    user.narrator? || record.chapters.exists?(id: user.current_chapter_id)
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
