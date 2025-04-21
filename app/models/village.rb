class Village < ApplicationRecord
  has_many :guilds, dependent: :destroy
  has_many :users, dependent: :nullify

  enum :village_type, {
    arcane_scholars: 0,     # TI
    lorekeepers: 1,         # RH/DP
    runemasters: 2,         # Marketing
    silver_tongues: 3,      # Comercial
    festbringers: 4,        # Eventos
    precision_crafters: 5,  # Qualidade
    coinwardens: 6          # Financeiro
  }
end
