class HonoraryTitlesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_honorary_title, only: [ :show, :update, :destroy ]

  def index
    @honorary_titles = policy_scope(HonoraryTitle)
    render json: @honorary_titles
  end

  def show
    render json: @honorary_title
  end

  def create
    @honorary_title = HonoraryTitle.new(honorary_title_params)
    authorize @honorary_title
    if @honorary_title.save
      render json: @honorary_title, status: :created
    else
      render json: @honorary_title.errors, status: :unprocessable_entity
    end
  end

  def update
    authorize @honorary_title
    if @honorary_title.update(honorary_title_params)
      render json: @honorary_title
    else
      render json: @honorary_title.errors, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @honorary_title
    @honorary_title.destroy
    head :no_content
  end

  private

  def set_honorary_title
    @honorary_title = HonoraryTitle.find(params[:id])
  end

  def honorary_title_params
    params.require(:honorary_title).permit(:name, :description, :character_id, :narrator_id, :logo)
  end
end
