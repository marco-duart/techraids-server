class Specialization < ApplicationRecord
  belongs_to :guild
  has_many :character_classes
  has_many :users
end
