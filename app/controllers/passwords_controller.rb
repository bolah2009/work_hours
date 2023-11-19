class PasswordsController < ApplicationController
  def update
    if current_user.authenticate(password_params[:old_password]) && current_user.update(update_password_params)
      notice = 'Password changed successfully!'
      notice_type = :success
    else
      notice = 'Unable to change password'
      notice_type = :error
    end

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(
          :user_password_notice,
          partial: 'shared/form_notice',
          assigns: { type: :user_password, errors: current_user.errors, notice:, notice_type: }
        )
      end
      format.html { redirect_to user_path(current_user), errors: current_user.errors, notice:, notice_type: }
    end
  end

  private

  def password_params
    params.require(:user).permit(:old_password, :password, :password_confirmation)
  end

  def update_password_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end
