class HonoraryTitlePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.narrator?
        scope.where(narrator_id: user.id)
      elsif user.character?
        scope.where(character_id: user.id)
      else
        scope.none
      end
    end
  end

  def index?
    user.narrator? || user.character?
  end

  def show?
    (user.narrator? && record.narrator_id == user.id) ||
    (user.character? && record.character_id == user.id)
  end

  def create?
    user.narrator?
  end

  def update?
    user.narrator? && record.narrator_id == user.id
  end

  def destroy?
    user.narrator? && record.narrator_id == user.id
  end

  def edit?
    update?
  end

  def new?
    create?
  end
end
