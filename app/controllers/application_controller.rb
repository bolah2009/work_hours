class ApplicationController < ActionController::Base
  add_flash_types :notice_type, :show_frame

  before_action :current_user
  before_action :require_login

  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  rescue_from ActiveRecord::RecordInvalid, with: :invalid

  def current_user
    return if session[:current_user_id].blank?

    @current_user ||= User.find_by(id: session[:current_user_id])
  end

  def require_login
    redirect_to sign_in_path, notice: 'You must be signed in', notice_type: :error if @current_user.blank?
  end

  delegate :id, to: :current_user, prefix: true

  def current_user_id
    @current_user_id ||= current_user&.id
  end

  private

  def not_found(error)
    redirect_to root_path, assigns: { notice: error.message, notice_type: :error }, status: :not_found
  end

  def invalid(error)
    redirect_to root_path, assigns: { notice: error.message, notice_type: :error }, status: :unprocessable_entity
  end
end
