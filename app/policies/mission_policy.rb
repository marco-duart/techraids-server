class MissionPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.narrator?
        scope.where(narrator: user)
      else
        scope.where(character: user)
      end
    end
  end

  def index?
    true
  end

  def show?
    record.narrator == user || record.character == user
  end

  def create?
    record.narrator == user
  end

  def update?
    record.narrator == user
  end

  def destroy?
    record.narrator == user
  end
end
