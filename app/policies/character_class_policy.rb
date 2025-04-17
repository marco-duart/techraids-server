class CharacterClassPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.narrator?
        scope.joins(:specialization).where(specializations: { guild: user.guild })
      elsif user.character?
        scope.where(
          specialization: user.specialization
        ).where(
          "required_experience <= ? AND entry_fee <= ?",
          user.experience,
          user.gold
        )
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
end
