class Mission < ApplicationRecord
  belongs_to :character, class_name: "User"
  belongs_to :chapter
  belongs_to :narrator, class_name: "User"
end
