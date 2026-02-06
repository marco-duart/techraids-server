class MissionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_mission, only: [ :show, :update, :destroy ]

  def index
    @missions = policy_scope(Mission)
    @missions = apply_filters(@missions)
    @missions = apply_sort(@missions)
    @pagy, @missions = pagy(@missions)
    render json: { data: @missions, pagy: pagy_to_json(@pagy) }
  end

  def show
    authorize @mission
    render json: @mission
  end

  def create
    @mission = Mission.new(mission_params)
    @mission.narrator = current_user
    authorize @mission

    if @mission.save
      render json: @mission, status: :created
    else
      render json: @mission.errors, status: :unprocessable_entity
    end
  end

  def update
    authorize @mission
    if @mission.update(mission_params)
      render json: @mission
    else
      render json: @mission.errors, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @mission
    @mission.destroy
    head :no_content
  end

  private

  def set_mission
    @mission = Mission.find(params[:id])
  end

  def mission_params
    params.require(:mission).permit(:title, :description, :status, :gold_reward, :character_id)
  end

  def apply_filters(relation)
    relation = relation.filter_by_status(params[:status]) if params[:status].present?

    if params[:gold_reward_min].present? || params[:gold_reward_max].present?
      relation = relation.filter_by_gold_reward(
        params[:gold_reward_min],
        params[:gold_reward_max]
      )
    end

    # Narrators can filter by character, characters cannot
    if current_user.narrator? && params[:character_id].present?
      relation = relation.filter_by_character(params[:character_id])
    end

    relation
  end

  def apply_sort(relation)
    field = params[:sort_by] || :updated_at
    direction = params[:sort_direction] || :desc
    relation.sort_by_field(field, direction)
  end

  def pagy_to_json(pagy_obj)
    {
      count: pagy_obj.count,
      page: pagy_obj.page,
      pages: pagy_obj.pages,
      from: pagy_obj.from,
      to: pagy_obj.to
    }
  end
end
