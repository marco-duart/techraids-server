class NarratorsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_narrator

  def performance_report
    result = Narrator::PerformanceService.new(current_user, performance_report_params).performance_report

    if result[:success]
      render json: result[:data], status: :ok
    else
      render json: { error: result[:message] }, status: :unprocessable_entity
    end
  end

  def guild_members
    result = Narrator::GuildService.new(current_user).guild_members

    if result[:success]
      render json: result[:data], status: :ok
    else
      render json: { error: result[:message] }, status: :unprocessable_entity
    end
  end

  def pending_rewards
    result = Narrator::GuildService.new(current_user).pending_rewards

    if result[:success]
      render json: result[:data], status: :ok
    else
      render json: { error: result[:message] }, status: :unprocessable_entity
    end
  end

  def deliver_reward
    result = Narrator::GuildService.new(current_user).deliver_reward(deliver_reward_params)

    if result[:success]
      render json: result[:data], status: :ok
    else
      render json: { error: result[:message] }, status: :unprocessable_entity
    end
  end

  private

  def performance_report_params
    params.permit(:start_date, :end_date)
  end

  def deliver_reward_params
    params.permit(:character_treasure_chest_id, :boss_id)
  end

  def authorize_narrator
    head :forbidden unless current_user.narrator?
  end
end
