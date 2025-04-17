class Specialization < ApplicationRecord
  belongs_to :guild
  has_many :character_classes, dependent: :destroy
  has_many :users, dependent: :nullify
end
