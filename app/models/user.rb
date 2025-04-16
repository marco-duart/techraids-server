class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  include DeviseTokenAuth::Concerns::User
  enum :role, { character: 0, narrator: 1 }

  belongs_to :village, optional: true
  belongs_to :guild, optional: true
  belongs_to :character_class, optional: true
  belongs_to :specialization, optional: true
  belongs_to :current_chapter, class_name: "Chapter", optional: true
  belongs_to :active_title, class_name: "HonoraryTitle", optional: true

  has_many :character_tasks, class_name: "Task", foreign_key: "character_id"
  has_many :tasks, class_name: "Task", foreign_key: "narrator_id"
  has_many :character_missions, class_name: "Mission", foreign_key: "character_id"
  has_many :missions, class_name: "Mission", foreign_key: "narrator_id"
  has_many :character_treasure_chests
  has_many :treasure_chests, through: :character_treasure_chests

  has_many :honorary_titles, class_name: "HonoraryTitle", foreign_key: "narrator_id"
  has_many :acquired_titles, class_name: "HonoraryTitle", foreign_key: "character_id"

  has_one_attached :photo

  validates :nickname, uniqueness: true

  after_create :set_initial_chapter, if: :character?

  def current_level
    (experience / 25).floor + 1
  end

  private

  def set_initial_chapter
    return unless guild.present? && guild.quest.present?

    first_chapter = guild.quest.chapters.first
    update(current_chapter: first_chapter) if first_chapter
  end
end
