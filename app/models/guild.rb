class Guild < ApplicationRecord
  belongs_to :village
  belongs_to :narrator, class_name: "User"
  has_many :characters, class_name: "User"
  has_one :quest
end
