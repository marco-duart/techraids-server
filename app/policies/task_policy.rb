class TaskPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.narrator?
        scope.all
      else
        scope.where(character: user)
      end
    end
  end

  def create?
    user.character?
  end

  def index?
    true
  end

  def show?
    user.narrator? || record.character == user
  end

  def update?
    user.narrator?
  end

  def destroy?
    return true if user.narrator?

    user.character? && record.character == user && record.pending?
  end
end
