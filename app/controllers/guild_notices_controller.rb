class GuildNoticesController < ApplicationController
  before_action :authenticate_user!

  def index
    @notices = policy_scope(GuildNotice)
    render json: @notices
  end

  def create
    @notice = GuildNotice.new(notice_params)
    authorize @notice

    if @notice.save
      render json: @notice, status: :created
    else
      render json: { errors: @notice.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    @notice = GuildNotice.find(params[:id])
    authorize @notice

    if @notice.update(notice_params)
      render json: @notice
    else
      render json: { errors: @notice.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @notice = GuildNotice.find(params[:id])
    authorize @notice
    @notice.destroy
    head :no_content
  end

  private

  def notice_params
    params.require(:guild_notice).permit(:title, :content, :priority, :active).merge(author: current_user, guild_id: current_user.guild_id)
  end
end
