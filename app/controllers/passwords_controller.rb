class PasswordsController < ApplicationController
  def update
    if current_user.authenticate(password_params[:old_password]) && current_user.update(update_password_params)
      set_flash(notice: 'Password changed successfully!', notice_type: :success)
    else
      set_flash(notice: 'Unable to change password', notice_type: :error)
    end
    redirect_to organization_user_path(organization_id, current_user), errors: current_user.errors
  end

  private

  def password_params
    params.require(:user).permit(:old_password, :password, :password_confirmation)
  end

  def update_password_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end
