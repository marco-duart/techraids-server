class Village < ApplicationRecord
  has_many :guilds, dependent: :destroy
  has_many :users, dependent: :nullify
end
