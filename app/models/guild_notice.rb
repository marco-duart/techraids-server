class GuildNotice < ApplicationRecord
  belongs_to :guild
  belongs_to :author, class_name: "User"

  validates :title, :content, presence: true
  enum priority: { low: 0, normal: 1, high: 2, critical: 3 }

  scope :active, -> { where(active: true).order(created_at: :desc) }
end
