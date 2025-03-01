# frozen_string_literal: true

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

  has_many :tasks
  has_many :missions
  has_many :character_treasure_chests
  has_many :treasure_chests, through: :character_treasure_chests
  has_many :honorary_titles

  has_one_attached :photo
end
