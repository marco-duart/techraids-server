class Quest < ApplicationRecord
  belongs_to :guild
  has_many :chapters
end
