class ArcaneAnnouncement < ApplicationRecord
  belongs_to :village
  belongs_to :author, class_name: "User"

  validates :title, :content, :announcement_type, presence: true

  enum :announcement_type, {
    arcane_decree: 0,       # TI
    lore_whisper: 2,        # RH/DP
    runic_proclamation: 1   # Marketing
  }
  enum :priority, { low: 0, normal: 1, high: 2, critical: 3 }

  scope :active, -> { where(active: true).order(created_at: :desc) }
end
