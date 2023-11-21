class SessionsController < ApplicationController
  before_action :authenticate, only: %i[new create]
  skip_before_action :require_login

  def new
    @user = User.new
    @show_frame = :sign_in
  end

  def create
    user = User.find_by(email: params[:email])
    if user.present? && user.authenticate(params[:password])
      session[:current_user_id] = user.id
      @show_frame = nil
      redirect_to root_path
    else
      set_flash(notice: 'invalid email or password', notice_type: :error)
      render :new, status: :unprocessable_entity,
                   assigns: { show_frame: :sign_in }
    end
  end

  def destroy
    session.delete(:current_user_id)
    @current_user = nil
    set_flash(notice: 'Logged out', notice_type: :info)
    redirect_to sign_in_path, status: :see_other
  end

  private

  def authenticate
    return unless session[:current_user_id]

    set_flash(notice: 'You are already logged in', notice_type: :info)
    redirect_to root_path
  end
end
