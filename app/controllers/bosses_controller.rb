class BossesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_boss, only: [ :show, :update, :destroy ]

  def index
    @bosses = policy_scope(Boss)
    render json: @bosses
  end

  def show
    render json: @boss
  end

  def create
    @boss = Boss.new(boss_params)
    authorize @boss
    if @boss.save
      render json: @boss, status: :created
    else
      render json: @boss.errors, status: :unprocessable_entity
    end
  end

  def update
    authorize @boss
    if @boss.update(boss_params)
      render json: @boss
    else
      render json: @boss.errors, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @boss
    @boss.destroy
    head :no_content
  end

  private

  def set_boss
    @boss = Boss.find(params[:id])
  end

  def boss_params
    params.require(:boss).permit(:name, :description, :chapter_id, :image)
  end
end
