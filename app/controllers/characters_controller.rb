class CharactersController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_character

  def select_specialization
    result = CharacterProgressionService.new(current_user).select_specialization(select_specialization_params)

    if result[:success]
      render json: result[:user], status: :ok
    else
      render json: { errors: result[:errors] }, status: :unprocessable_entity
    end
  end

  def switch_character_class
    result = CharacterProgressionService.new(current_user).switch_character_class(switch_character_class_params)

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

  def ranking
    result = CharactersRankingService.new(current_user).guild_ranking
    if result[:success]
      render json: result[:data], status: :ok
    else
      render json: { error: result[:error] }, status: :not_found
    end
  end

  def store_items
    result = CharacterStoreService.new(current_user).store_items

    if result[:success]
      render json: result[:data], status: :ok
    else
      render json: { error: result[:error] }, status: :forbidden
    end
  end

  def purchase_chest
    result = CharacterStoreService.new(current_user).purchase_chest(purchase_chest_params)

    if result[:success]
      render json: result[:data], status: :ok
    else
      render json: { error: result[:error] }, status: :unprocessable_entity
    end
  end

  def purchase_history
    result = CharacterStoreService.new(current_user).purchase_history

    if result[:success]
      render json: result[:data], status: :ok
    else
      render json: { error: result[:error] }, status: :forbidden
    end
  end

  def switch_active_title
    result = CharacterProgressionService.new(current_user).switch_active_title(switch_active_title_params)

    if result[:success]
      render json: result, status: :ok
    else
      render json: { errors: result[:errors] || result[:error] },
             status: result[:error] ? :not_found : :unprocessable_entity
    end
  end

  private

  def purchase_chest_params
    params.require(:treasure_chest_id)
  end

  def switch_character_class_params
    params.require(:character_class_id)
  end

  def select_specialization_params
    params.require(:specialization_id)
  end

  def switch_active_title_params
    params.require(:honorary_title_id)
  end

  def authorize_character
    head :forbidden unless current_user.character?
  end
end
