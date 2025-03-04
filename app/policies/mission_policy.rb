class MissionPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.narrator?
        scope.all
      else
        scope.where(character: user)
      end
    end
  end

  def index?
    true
  end

  def show?
    user.narrator? || record.character == user
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
