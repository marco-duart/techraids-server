class CharacterClass < ApplicationRecord
  belongs_to :specialization
  has_many :users
  has_one_attached :image
end
