class ChaptersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_chapter, only: [ :show, :update, :destroy ]

  def index
    @chapters = policy_scope(Chapter)
    render json: @chapters
  end

  def show
    authorize @chapter
    render json: @chapter
  end

  def create
    @chapter = Chapter.new(chapter_params)
    authorize @chapter

    if @chapter.save
      render json: @chapter, status: :created
    else
      render json: @chapter.errors, status: :unprocessable_entity
    end
  end

  def update
    authorize @chapter
    if @chapter.update(chapter_params)
      render json: @chapter
    else
      render json: @chapter.errors, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @chapter
    @chapter.destroy
    head :no_content
  end

  private

  def set_chapter
    @chapter = Chapter.find(params[:id])
  end

  def chapter_params
    params.require(:chapter).permit(:title, :description, :required_experience, :quest_id)
  end
end
