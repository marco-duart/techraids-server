class SpecializationsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_narrator
  before_action :set_specialization, only: [ :show, :update, :destroy ]

  def index
    @specializations = Specialization.all
    render json: @specializations
  end

  def show
    render json: @specialization
  end

  def create
    @specialization = Specialization.new(specialization_params)
    authorize @specialization

    if @specialization.save
      render json: @specialization, status: :created
    else
      render json: @specialization.errors, status: :unprocessable_entity
    end
  end

  def update
    authorize @specialization
    if @specialization.update(specialization_params)
      render json: @specialization
    else
      render json: @specialization.errors, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @specialization
    @specialization.destroy
    head :no_content
  end

  private

  def set_specialization
    @specialization = Specialization.find(params[:id])
  end

  def specialization_params
    params.require(:specialization).permit(:title, :description)
  end

  def authorize_narrator
    head :forbidden unless current_user.narrator?
  end
end
