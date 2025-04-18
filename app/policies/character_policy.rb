class CharacterPolicy < ApplicationPolicy
  def switch_class?
    user.character? &&
    user.specialization == record.specialization &&
    user.experience >= record.required_experience &&
    user.gold >= record.entry_fee
  end

  def select_specialization?
    user.character? && user.specialization.nil? && user.guild == record.guild
  end
end
