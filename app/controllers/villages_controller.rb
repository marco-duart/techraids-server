class VillagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_village, only: [ :show, :update, :destroy ]

  def index
    @villages = policy_scope(Village)
    render json: @villages
  end

  def show
    authorize @village
    render json: @village
  end

  def create
    @village = Village.new(village_params)
    authorize @village

    if @village.save
      render json: @village, status: :created
    else
      render json: @village.errors, status: :unprocessable_entity
    end
  end

  def update
    authorize @village
    if @village.update(village_params)
      render json: @village
    else
      render json: @village.errors, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @village
    @village.destroy
    head :no_content
  end

  private

  def set_village
    @village = Village.find(params[:id])
  end

  def village_params
    params.require(:village).permit(:name, :description)
  end
end
