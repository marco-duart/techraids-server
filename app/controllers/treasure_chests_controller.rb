class TreasureChestsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_treasure_chest, only: [ :show, :activate, :deactivate ]

  def index
    @treasure_chests = policy_scope(TreasureChest)
    render json: @treasure_chests
  end

  def show
    render json: @treasure_chest
  end

  def create
    @treasure_chest = TreasureChest.new(treasure_chest_params)
    @treasure_chest.guild = current_user.managed_guild if current_user.managed_guild.present?
    authorize @treasure_chest

    if @treasure_chest.save
      render json: @treasure_chest, status: :created
    else
      render json: @treasure_chest.errors, status: :unprocessable_entity
    end
  end

  def activate
    authorize @treasure_chest
    @treasure_chest.update(active: true)
    render json: @treasure_chest
  end

  def deactivate
    authorize @treasure_chest
    @treasure_chest.update(active: false)
    render json: @treasure_chest
  end

  private

  def set_treasure_chest
    @treasure_chest = TreasureChest.find(params[:id])
  end

  def treasure_chest_params
    params.require(:treasure_chest).permit(:title, :value, :active)
  end
end
