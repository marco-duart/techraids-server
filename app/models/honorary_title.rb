class HonoraryTitle < ApplicationRecord
  belongs_to :character, class_name: "User"
  belongs_to :narrator, class_name: "User"
  has_one_attached :logo
end
