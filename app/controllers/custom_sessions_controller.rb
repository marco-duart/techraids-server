class CustomSessionsController < DeviseTokenAuth::SessionsController
  protected

  def render_create_success
    user_json = @resource.as_json(include: [
      :village,
      :guild,
      :specialization
    ]).merge(
      photo_url: @resource.photo.attached? ? rails_blob_url(@resource.photo) : nil,
      current_level: @resource.current_level
    )

    if @resource.character_class
      user_json[:character_class] = @resource.character_class.as_json
    else
      user_json[:character_class] = nil
    end

    render json: { data: user_json }
  end
end
