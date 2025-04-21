class GuildNoticesController < ApplicationController
  before_action :authenticate_user!

  def index
    @notices = policy_scope(GuildNotice)
    render json: @notices
  end
end
