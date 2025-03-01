class Village < ApplicationRecord
  has_many :guilds
  has_many :users
end
