class CustomTokenValidationsController < DeviseTokenAuth::TokenValidationsController
  def validate_token
    if @resource = current_user
      render_validate_token_success
    else
      render_validate_token_error
    end
  end

  protected

  def render_validate_token_success
    user_json = @resource.as_json(include: [
      :village,
      :guild,
      :specialization,
      :active_title,
      :acquired_titles
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

  def render_validate_token_error
    render json: {
      success: false,
      errors: [ "Sessão inválida ou expirada" ]
    }, status: :unauthorized
  end
end
