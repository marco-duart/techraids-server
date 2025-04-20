class Reward < ApplicationRecord
  belongs_to :treasure_chest

  enum :reward_type, {
    physical_item: 0,
    digital_content: 1,
    in_game_benefit: 2,
    real_life_experience: 3
  }

  validates :name, :description, :reward_type, presence: true

  scope :available, -> {
    where("(is_limited = false) OR (is_limited = true AND stock_quantity > 0)")
  }

  def available?
    !is_limited || (is_limited && stock_quantity > 0)
  end
end
