class OrganizationsController < ApplicationController
  before_action :_organizations, only: %i[show index]

  def index; end

  def show
    @organization = @organizations.find(params[:id])

    @organization_id = @organization.id
    @users = @organization.users.distinct
    @metrics = user_aggregated_metrics
  end

  def new; end

  def create
    organization = Organization.create(name: organization_params[:name])

    if organization.save
      owner_role = Role.find_by(name: 'owner')
      organization_member = current_user.memberships.create(role: owner_role, organization:) # TODO: Move to model?

      if organization_member.save
        set_flash(notice: 'Organization successfully created!', notice_type: :success)
        return render :index
      end
    end
    set_flash(notice: organization.errors.first.full_message, notice_type: :error)
    render :index, status: :unprocessable_entity
  end

  private

  def _organizations
    @organizations ||= current_user.organizations
  end

  def user_aggregated_metrics
    condition = [organization_id: @organization_id]

    # scope data to only specific user when user is only a member
    if !current_user.admin?(@organization_id) || !current_user.owner?(@organization_id)
      condition.push(user_id: current_user_id)
    end

    Metric.user_aggregated_metrics(*condition)
  end

  def organization_params
    params.require(:organization).permit(:name)
  end
end
