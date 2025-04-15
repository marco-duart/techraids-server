class CharacterClassPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.narrator?
        scope.joins(:specialization).where(specializations: { guild: user.guild })
      else user.character?
        scope.where(specialization: user.specialization)
      end
    end
  end

  def create?
    user.narrator? && record.specialization.guild == user.guild
  end

  def update?
    user.narrator? && record.specialization.guild == user.guild
  end

  def destroy?
    user.narrator? && record.specialization.guild == user.guild
  end

  def switch?
    user.character? &&
    record.specialization == user.specialization &&
    record.required_experience <= user.experience &&
    record.entry_fee <= user.gold
  end
end
