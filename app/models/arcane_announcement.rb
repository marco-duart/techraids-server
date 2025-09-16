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

  def self.announcement_type_for_village(village_type)
    case village_type.to_sym
    when :arcane_scholars then :arcane_decree
    when :runemasters then :runic_proclamation
    when :lorekeepers then :lore_whisper
    else
      nil
    end
  end

  private

  def set_announcement_type_from_village
    self.announcement_type = ArcaneAnnouncement.announcement_type_for_village(village.village_type)
  end
end
