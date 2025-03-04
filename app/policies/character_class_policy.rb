class CharacterClassPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
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

  def switch?
    user.character? && record.required_experience <= user.experience && record.entry_fee <= user.gold
  end
end
