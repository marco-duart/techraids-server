class UsersController < ApplicationController
  before_action :authenticate_user!

  def update_password
    if current_user.update_with_password(password_params)
      current_user.create_new_auth_token if current_user == current_user
      render json: { success: true, message: "Senha atualizada" }
    else
      render json: { errors: current_user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update_photo
    if current_user.update(photo_params)
      render json: {
        success: true,
        message: "Foto atualizada",
        photo_url: current_user.photo.attached? ? rails_blob_url(current_user.photo) : nil
      }
    else
      render json: { errors: current_user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def password_params
    params.permit(
      :current_password,
      :password,
      :password_confirmation
    )
  end

  def photo_params
    params.permit(:photo)
  end
end
