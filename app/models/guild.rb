class Guild < ApplicationRecord
  belongs_to :village
  belongs_to :narrator, class_name: "User"
  has_many :characters, class_name: "User", dependent: :nullify
  has_many :specializations, dependent: :destroy
  has_many :treasure_chests, dependent: :destroy
  has_one :quest, dependent: :destroy
end
