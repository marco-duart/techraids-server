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
  has_many :honorary_titles

  has_one_attached :photo

  def current_level
    return 1 if experience.to_i <= 0

    chapters = Chapter.order(:required_experience)

    return 1 if chapters.empty? || experience < chapters.first.required_experience

    chapters.reverse_each do |chapter|
      return chapter.id if experience >= chapter.required_experience
    end

    1
  end
end
