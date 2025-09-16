class ArcaneAnnouncementsController < ApplicationController
  before_action :authenticate_user!

  def index
    @announcements = policy_scope(ArcaneAnnouncement)
                  .active
                  .select(
                    "arcane_announcements.*",
                    "users.name as author_name",
                    "users.nickname as author_nickname"
                  )
                  .joins(:author)
                  .order(created_at: :desc)

  render json: @announcements.as_json(
    methods: [ :author_name, :author_nickname ]
  )
  end

  def create
    @announcement = ArcaneAnnouncement.new(announcement_params)
    @announcement.author = current_user
    @announcement.village = current_user.village

    unless @announcement.announcement_type.present?
      render json: { error: "Sua vila não tem permissão para criar anúncios" },
             status: :forbidden
      return
    end

    if @announcement.save
      render json: @announcement, status: :created
    else
      render json: @announcement.errors, status: :unprocessable_entity
    end
  end

  def update
    @announcement = ArcaneAnnouncement.find(params[:id])
    authorize @announcement

    if @announcement.update(announcement_params)
      render json: @announcement
    else
      render json: { errors: @announcement.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @announcement = ArcaneAnnouncement.find(params[:id])
    authorize @announcement
    @announcement.destroy
    head :no_content
  end

  private

  def announcement_params
    params.require(:arcane_announcement).permit(:title, :content, :priority, :active)
  end
end
