class ApplicationController < ActionController::Base
  add_flash_types :notice_type

  before_action :current_user
  before_action :require_login

  before_action :set_current_user_organizations
  before_action :set_organization_users

  def current_user
    return if session[:current_user_id].blank?

    @current_user ||= User.find_by(id: session[:current_user_id])
  end

  def current_organization
    return if organization_id.blank?

    @current_organization ||= Organization.find_by(id: organization_id)
  end

  def require_login
    redirect_to sign_in_path, notice: 'You must be signed in', notice_type: :error if @current_user.blank?
  end

  delegate :id, to: :current_user, prefix: true
  delegate :id, to: :current_organization, prefix: true

  def current_user_id
    @current_user_id ||= current_user&.id
  end

  def current_organization_id
    @current_organization_id ||= current_organization&.id
  end

  private

  def set_organization_users
    return if current_organization_id.blank?
    return unless current_user_is_admin_or_owner?

    @users = Organization.find_by(id: current_organization_id).users.distinct
  end

  def set_current_user_organizations
    return if current_user.blank?

    @organizations = current_user.organizations.distinct
  end

  def current_user_is_admin_or_owner?
    current_user.admin?(current_organization_id) || current_user.owner?(current_organization_id)
  end

  def organization_id
    params[:organization_id]
  end

  def set_flash(notice: nil, notice_type: nil)
    flash.now[:notice] = notice if notice
    flash.now[:notice_type] = notice_type if notice_type
  end
end
