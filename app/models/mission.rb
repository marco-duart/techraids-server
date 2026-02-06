class Mission < ApplicationRecord
  belongs_to :character, class_name: "User"
  belongs_to :narrator, class_name: "User"

  enum :status, { pending: 0, approved: 1, rejected: 2 }

  scope :last_pending, -> { pending.order(created_at: :desc).first }
  scope :filter_by_status, ->(status) { where(status: status) if status.present? }
  scope :filter_by_gold_reward, ->(min, max) do
    relation = all
    relation = relation.where("gold_reward >= ?", min) if min.present?
    relation = relation.where("gold_reward <= ?", max) if max.present?
    relation
  end
  scope :filter_by_character, ->(character_id) { where(character_id: character_id) if character_id.present? }
  scope :sort_by_field, ->(field, direction) do
    if %w[status gold_reward created_at updated_at].include?(field) &&
       %w[asc desc].include?(direction)
      order(field => direction)
    else
      order(updated_at: :desc)
    end
  end

  before_update :prevent_update_if_approved, if: :gold_reward_present?
  after_update :reward_character_gold, if: :saved_change_to_status?

  private

  def gold_reward_present?
    gold_reward.present? && gold_reward.positive?
  end

  def prevent_update_if_approved
    if status_was == "approved" && status_changed?
      errors.add(:base, "Missões aprovadas não podem ser alteradas")
      throw :abort
    end
  end

  def reward_character_gold
    return unless status == "approved" && status_before_last_save != "approved"

    Mission.transaction do
      mission = Mission.lock.find(id)
      user = User.lock.find(character_id)

      user.update!(gold: user.gold + mission.gold_reward)
    end
  end
end
