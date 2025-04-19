class UserPolicy < ApplicationPolicy
  def update_password?
    user == record
  end

  def update_photo?
    user == record
  end
end
