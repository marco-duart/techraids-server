class VillagePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.narrator?
        scope.all
      else
        scope.where(id: user.village_id)
      end
    end
  end

  def index?
    true
  end

  def show?
    user.narrator? || record.id == user.village_id
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
