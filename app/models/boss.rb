class Boss < ApplicationRecord
  belongs_to :chapter
  belongs_to :finishing_character, class_name: "User", optional: true
  has_one :quest, through: :chapter
  has_one :guild, through: :quest
  has_one_attached :image

  def as_json(options = {})
    super(options).merge(image_url: image.attached? ? Rails.application.routes.url_helpers.url_for(image) : nil)
  end

  def defeat_threshold
    team_members = guild.characters
    team_size = team_members.count

    base_experience = chapter.required_experience * 1.2

    additional_members = [ team_size - 1, 0 ].max
    additional_experience = chapter.required_experience * 0.80 * additional_members

    (base_experience + additional_experience).round
  end

  def team_can_defeat?
    team_members = guild.characters.where(current_chapter_id: chapter.id)
    total_experience = team_members.sum(:experience)

    total_experience >= defeat_threshold
  end

  def finishing_hero?(character)
    return false unless team_can_defeat?

    guild.characters
         .where(current_chapter_id: chapter.id)
         .order(experience: :desc)
         .first == character
  end
end
