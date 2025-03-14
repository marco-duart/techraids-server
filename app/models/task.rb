class Task < ApplicationRecord
  belongs_to :character, class_name: "User"
  belongs_to :chapter
  belongs_to :narrator, class_name: "User"

  enum :status, { pending: 0, approved: 1, rejected: 2 }

  scope :last_pending, -> { pending.order(created_at: :desc).first }
end
