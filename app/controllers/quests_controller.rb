class QuestsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_quest, only: [ :show, :update, :destroy ]

  def index
    @quests = policy_scope(Quest)
    render json: @quests
  end

  def show
    authorize @quest
    render json: @quest
  end

  def create
    @quest = Quest.new(quest_params)
    authorize @quest

    if @quest.save
      render json: @quest, status: :created
    else
      render json: @quest.errors, status: :unprocessable_entity
    end
  end

  def update
    authorize @quest
    if @quest.update(quest_params)
      render json: @quest
    else
      render json: @quest.errors, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @quest
    @quest.destroy
    head :no_content
  end

  private

  def set_quest
    @quest = Quest.find(params[:id])
  end

  def quest_params
    params.require(:quest).permit(:title, :description, :guild_id)
  end
end
