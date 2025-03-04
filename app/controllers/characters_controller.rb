class Characters::ProgressionsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_character

  def select_specialization
    authorize current_user, :select?, policy_class: SpecializationPolicy

    if current_user.update(specialization_id: params[:specialization_id])
      render json: current_user, status: :ok
    else
      render json: current_user.errors, status: :unprocessable_entity
    end
  end

  def switch_character_class
    character_class = CharacterClass.find(params[:character_class_id])
    authorize character_class, :switch?

    if current_user.gold >= character_class.entry_fee && current_user.experience >= character_class.required_experience
      current_user.update(character_class_id: character_class.id, gold: current_user.gold - character_class.entry_fee)
      render json: current_user, status: :ok
    else
      render json: { error: "Você não tem recursos suficientes para trocar de classe." }, status: :unprocessable_entity
    end
  end

  private

  def authorize_character
    head :forbidden unless current_user.character?
  end
end
