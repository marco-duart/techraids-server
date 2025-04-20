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

  def purchase_chest?
    user.character? &&
    user.guild.present? &&
    record.guild_id == user.guild_id
  end

  def view_store?
    user.character? &&
    user.guild.present?
  end

  def view_purchase_history?
    user.character?
  end
end
