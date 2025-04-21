class ArcaneAnnouncementPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def create?
    return false unless user.present? && user.village.present?

    case user.role.to_sym
    when :narrator
      user.village.arcane_scholars? ||
      user.village.runemasters? ||
      user.village.lorekeepers?
    when :character
      user.village.lorekeepers?
    else
      false
    end
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
