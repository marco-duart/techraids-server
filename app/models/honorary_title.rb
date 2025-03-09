class HonoraryTitle < ApplicationRecord
  belongs_to :character, class_name: "User"
  belongs_to :narrator, class_name: "User"
  has_one_attached :logo

  def as_json(options = {})
    super(options).merge(logo_url: logo.attached? ? Rails.application.routes.url_helpers.url_for(logo) : nil)
  end
end
