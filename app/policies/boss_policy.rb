class BossPolicy < ApplicationPolicy
  def index?
    user.narrator?
  end

  def show?
    user.narrator?
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
