class Boss < ApplicationRecord
  belongs_to :chapter
  has_one_attached :image
end
