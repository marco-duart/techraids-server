class Quest < ApplicationRecord
  belongs_to :guild
  has_many :chapters
  has_many :bosses, through: :chapters
end
