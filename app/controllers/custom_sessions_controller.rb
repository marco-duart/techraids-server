class CustomSessionsController < DeviseTokenAuth::SessionsController
  protected

  def render_create_success
    render json: {
      data: @resource.as_json(include: [ :village, :guild, :character_class, :specialization ]).merge(
        photo_url: @resource.photo.attached? ? rails_blob_url(@resource.photo) : nil
      )
    }
  end
end
