class TaskPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.where(narrator: user)
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
    record.narrator == user || record.character == user
  end

  def update?
    record.narrator == user
  end

  def destroy?
    return true if user.narrator?

    user.character? && record.character == user && record.pending?
  end
end
