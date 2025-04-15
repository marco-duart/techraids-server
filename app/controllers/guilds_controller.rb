
class GuildsController < ApplicationController
  before_action :authenticate_user!, only: [ :index, :show, :update, :destroy, :create ]
  before_action :set_guild, only: [ :show, :update, :destroy ]

  def simple_list
    @guilds = Guild.select(:id, :name)
    render json: @guilds
  end

  def index
    @guilds = policy_scope(Guild)
    render json: @guilds
  end

  def show
    authorize @guild
    render json: @guild
  end

  def create
    @guild = Guild.new(guild_params)
    @guild.narrator = current_user
    authorize @guild

    if @guild.save
      render json: @guild, status: :created
    else
      render json: @guild.errors, status: :unprocessable_entity
    end
  end

  def update
    authorize @guild
    if @guild.update(guild_params)
      render json: @guild
    else
      render json: @guild.errors, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @guild
    @guild.destroy
    head :no_content
  end

  private

  def set_guild
    @guild = Guild.find(params[:id])
  end

  def guild_params
    params.require(:guild).permit(:name, :description, :village_id, :narrator_id)
  end
end
