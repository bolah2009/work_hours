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
      redirect_to root_path
    else
      render :new, status: :unprocessable_entity,
                   assigns: { notice: 'invalid email or password', notice_type: :error, show_frame: :sign_in }
    end
  end

  def destroy
    session.delete(:current_user_id)
    session.delete(:current_organization_id)
    @current_user = nil
    redirect_to sign_in_path, notice: 'Logged out', notice_type: :info, status: :see_other
  end

  private

  def authenticate
    redirect_to root_path, notice: 'You are already logged in', notice_type: :info if session[:current_user_id]
  end
end
