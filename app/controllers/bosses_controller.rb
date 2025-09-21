class BossesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_boss, only: [ :show, :update, :destroy ]

  def index
    @bosses = policy_scope(Boss).select(
                                  "bosses.*",
                                  "chapters.title as chapter_title",
                                )
                                .joins(:chapter)
                                .order(created_at: :desc)
    render json: @bosses
  end

  def show
    authorize @boss
    render json: @boss
  end

  def create
    chapter = Chapter.find_by(id: create_boss_params[:chapter_id])

    if chapter.nil? || chapter.quest.guild_id != current_user.managed_guild&.id
      render json: { error: "Chapter não pertence à sua guild" }, status: :unprocessable_entity
      return
    end

    @boss = Boss.new(create_boss_params)
    authorize @boss

    if @boss.save
      render json: @boss, status: :created
    else
      render json: @boss.errors, status: :unprocessable_entity
    end
  end

  def update
    authorize @boss
    if @boss.update(update_boss_params)
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

  def create_boss_params
    params.require(:boss).permit(:name, :description, :slogan, :chapter_id, :image, :reward_description)
  end

  def update_boss_params
    params.require(:boss).permit(:name, :description, :slogan, :image, :reward_description)
  end
end
