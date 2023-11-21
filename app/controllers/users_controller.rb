class UsersController < ApplicationController
  layout 'sessions', only: %i[new create]

  skip_before_action :require_login, only: %i[new create]
  before_action :prevent_registrations, only: %i[new create]

  before_action :require_current_user, only: :edit
  before_action :set_user, only: %i[edit show]

  # GET /users/1
  def show
    set_organization_and_metrics
  end

  # GET /users/new
  def new
    @user = User.new
    @show_frame = :sign_up
  end

  def edit
    @user = current_user
  end

  # POST /users or /users.json
  def create
    @user = User.new(user_params)

    if @user.save
      session[:current_user_id] = @user.id
      @current_user = @user
      set_flash(notice: 'Account created successfully!', notice_type: :success)
      redirect_to root_path
    else
      set_flash(notice: 'Account creation was unsuccessful.', notice_type: :error)
      render :new, status: :unprocessable_entity
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  def set_organization_and_metrics
    organization_id = params[:organization_id]
    @organization = Organization.find_by(id: organization_id)
    return redirect_to root_path if @organization.blank?

    @metrics = if !current_user.admin?(organization_id) && !current_user.owner?(organization_id)
                 Metric.user_metrics(organization_id:, user_id: current_user_id)
               else
                 Metric.user_metrics(organization_id:, user_id: params[:id])
               end
  end

  # Only allow a list of trusted parameters through.
  def user_params
    params.require(:user).permit(:name, :email, :password)
  end

  def prevent_registrations
    return if @current_user.blank?

    set_flash(notice: 'You already have an account', notice_type: :info)
    redirect_to root_path
  end

  def require_current_user
    return if current_user_id == params[:id].to_i

    redirect_to root_path
  end
end
