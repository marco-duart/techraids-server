class ArcaneAnnouncementsController < ApplicationController
  before_action :authenticate_user!

  def index
    @announcements = policy_scope(ArcaneAnnouncement).order(created_at: :desc)
    render json: @announcements
  end
end
