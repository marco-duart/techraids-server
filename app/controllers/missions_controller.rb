class MissionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_mission, only: [ :show, :update, :destroy ]

  def index
    @missions = policy_scope(Mission)
    render json: @missions
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
    params.require(:mission).permit(:title, :description, :status, :chapter_id, :character_id)
  end
end
