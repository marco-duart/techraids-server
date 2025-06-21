class RewardsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_reward, only: [ :show, :restock, :remove_stock ]

  def index
    @rewards = policy_scope(Reward)
    render json: @rewards
  end

  def show
    render json: @reward
  end

  def create
    @reward = Reward.new(reward_params)
    authorize @reward
    if @reward.save
      render json: @reward, status: :created
    else
      render json: @reward.errors, status: :unprocessable_entity
    end
  end

  def restock
    authorize @reward
    quantity = @reward.stock_quantity + params[:quantity].to_i

    if quantity > 0
      @reward.update(stock_quantity: quantity)
      render json: @reward
    else
      render json: { error: "A quantidade deve ser um número positivo." }, status: :unprocessable_entity
    end
  end

  def remove_stock
    authorize @reward
    @reward.stock_quantity = 0

    if @reward.save
      render json: { message: "Estoque removido com sucesso." }, status: :ok
    else
      render json: @reward.errors, status: :unprocessable_entity
    end
  end

  private

  def set_reward
    @reward = Reward.find(params[:id])
  end

  def reward_params
    params.require(:reward).permit(:name, :description, :reward_type, :is_limited, :stock_quantity, :treasure_chest_id)
  end
end
