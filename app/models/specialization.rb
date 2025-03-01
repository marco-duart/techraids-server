class Specialization < ApplicationRecord
  has_many :character_classes
  has_many :users
end
