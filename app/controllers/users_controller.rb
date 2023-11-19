class UsersController < ApplicationController
  skip_before_action :require_login, only: %i[new create]
  before_action :require_current_user, only: %i[update edit]
  before_action :set_user,
                only: %i[edit update]
  before_action :prevent_registrations, only: %i[new create]

  # GET /users/1
  def show; end

  # GET /users/new
  def new
    @user = User.new
    @show_frame = :sign_up
  end

  def edit
    @user = current_user
  end

  # POST /users
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        session[:current_user_id] = @user.id
        @current_user = @user
        format.html { render :show, assigns: { notice: 'Account created successfully!', notice_type: :success } }
      else
        format.html do
          render :new, status: :unprocessable_entity,
                       assigns: { notice: 'Account creation was unsuccessful.', notice_type: :error }
        end
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH /users/1 or /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params_update)
        format.html do
          render :show, status: :ok, assigns: { notice: 'User was successfully updated.', notice_type: :success }
        end
        format.json { render :show, status: :ok, location: @user }
      else
        format.html do
          render :show, status: :unprocessable_entity, errors: @user.errors,
                        assigns: { notice: 'Updated unsuccesful', notice_type: :error }
        end
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def user_params
    params.require(:user).permit(:name, :email, :password)
  end

  # Do not allow password and email update
  def user_params_update
    params.require(:user).permit(:name)
  end

  def prevent_registrations
    return if @current_user.blank?

    redirect_to root_path,
                assigns: { notice: 'You already have an account', notice_type: :info }
  end

  def require_current_user
    return if current_user_id == params[:id].to_i

    redirect_to user_path current_user_id
  end
end
