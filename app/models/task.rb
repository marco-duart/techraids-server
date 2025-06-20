class Task < ApplicationRecord
  belongs_to :character, class_name: "User"
  belongs_to :narrator, class_name: "User"

  enum :status, { pending: 0, approved: 1, rejected: 2 }

  scope :last_pending, -> { pending.order(created_at: :desc).first }

  before_update :prevent_update_if_approved, if: :experience_reward_present?
  after_update :reward_character_experience, if: :saved_change_to_status?

  private

  def experience_reward_present?
    experience_reward.present? && experience_reward.positive?
  end

  def prevent_update_if_approved
    if status_was == "approved" && status_changed?
      errors.add(:base, "Tarefas aprovadas não podem ser alteradas")
      throw :abort
    end
  end

  def reward_character_experience
    return unless status == "approved" && status_before_last_save != "approved"

    Task.transaction do
      task = Task.lock.find(id)
      user = User.lock.find(character_id)

      user.update!(experience: user.experience + task.experience_reward)
    end
  end
end
