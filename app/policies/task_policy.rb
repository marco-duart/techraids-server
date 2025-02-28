class TaskPolicy < ApplicationPolicy
  def create?
    user.character?
  end

  def update?
    user.narrator?
  end

  def destroy?
    user.narrator?
  end
end
