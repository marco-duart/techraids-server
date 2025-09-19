class ArcaneAnnouncementPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.narrator?
        scope.where(author: user)
      elsif user.character?
        scope.all
      end
    end
  end

  def create?
    user&.narrator? && user.village&.magical_support?
  end

  def show?
    true
  end

  def index?
    true
  end

  def update?
    record.author == user
  end

  def destroy?
    update?
  end
end
