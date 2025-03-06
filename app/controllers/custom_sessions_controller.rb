class CustomSessionsController < DeviseTokenAuth::SessionsController
  protected

  def render_create_success
    render json: {
      data: @resource.as_json(include: [ :village, :guild, :character_class, :specialization, :photo_attachment ])
    }
  end
end
