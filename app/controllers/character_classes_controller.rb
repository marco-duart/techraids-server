class CharacterClassesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_character_class, only: [ :show, :update, :destroy ]

  def index
    @character_classes = policy_scope(CharacterClass)
    render json: @character_classes
  end

  def show
    authorize @character_class
    render json: @character_class
  end

  def create
    @character_class = CharacterClass.new(character_class_params)
    authorize @character_class

    if @character_class.save
      render json: @character_class, status: :created
    else
      render json: @character_class.errors, status: :unprocessable_entity
    end
  end

  def update
    authorize @character_class
    if @character_class.update(character_class_params)
      render json: @character_class
    else
      render json: @character_class.errors, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @character_class
    @character_class.destroy
    head :no_content
  end

  private

  def set_character_class
    @character_class = CharacterClass.find(params[:id])
  end

  def character_class_params
    params.require(:character_class).permit(:name, :slogan, :required_experience, :entry_fee, :specialization_id, :image)
  end
end
