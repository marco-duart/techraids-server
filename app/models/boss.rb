class Boss < ApplicationRecord
  belongs_to :chapter
  has_one_attached :image

  def as_json(options = {})
    super(options).merge(image_url: image.attached? ? Rails.application.routes.url_helpers.url_for(image) : nil)
  end
end
