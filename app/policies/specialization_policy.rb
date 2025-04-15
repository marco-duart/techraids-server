class SpecializationPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.narrator?
        scope.where(guild: user.guild)
      else
        scope.where(guild: user.guild)
      end
    end
  end

  def create?
    user.narrator? && record.guild == user.guild
  end

  def update?
    user.narrator? && record.guild == user.guild
  end

  def destroy?
    user.narrator? && record.guild == user.guild
  end

  def select?
    user.character? && user.specialization.nil? && record.guild == user.guild
  end
end
