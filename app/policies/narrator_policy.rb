class NarratorPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def performance_report?
    user.narrator? && user.managed_guild.present?
  end

  def guild_members?
    user.narrator? && user.managed_guild.present?
  end

  def pending_rewards?
    user.narrator? && user.managed_guild.present?
  end

  def deliver_reward?
    user.narrator? && record == user.managed_guild.id
  end
end
