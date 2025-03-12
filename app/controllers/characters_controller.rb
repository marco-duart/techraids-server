class CharactersController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_character

  def select_specialization
    result = CharacterProgressionService.new(current_user).select_specialization(params[:specialization_id])

    if result[:success]
      render json: result[:user], status: :ok
    else
      render json: { errors: result[:errors] }, status: :unprocessable_entity
    end
  end

  def switch_character_class
    result = CharacterProgressionService.new(current_user).switch_character_class(params[:character_class_id])

    if result[:success]
      render json: result[:user], status: :ok
    else
      render json: { error: result[:error] }, status: :unprocessable_entity
    end
  end

  def character_quest
    result = CharacterQuestService.new(current_user).fetch_quest_and_companions

    if result[:success]
      render json: result[:data], status: :ok
    else
      render json: { error: result[:error] }, status: :not_found
    end
  end

  private

  def authorize_character
    head :forbidden unless current_user.character?
  end
end
