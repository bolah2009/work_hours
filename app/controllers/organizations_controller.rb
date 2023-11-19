class OrganizationsController < ApplicationController
  before_action :set_organizations, only: %i[show index]

  def index; end

  def show
    # debugger
    @organization = @organizations.find(params[:id])

    @organization_id = @organization.id
    session[:current_organization_id] = @organization_id
  end

  def new; end

  def create
    organization = Organization.create(name: organization_params[:name])

    if organization.save
      owner_role = Role.find_by(name: 'owner')
      organization_member = current_user.memberships.create(role: owner_role, organization:) # TODO: Move to model?

      if organization_member.save
        render :index
      else
        redirect_to organizations_path, assigns: {
                                          notice: organization_member.errors.first.full_message,
                                          notice_type: :error
                                        },
                                        status: :unprocessable_entity
      end
    else
      @notice = organization.errors.first.full_message
      @notice_type = :error
      render :index, status: :unprocessable_entity
    end
  end

  private

  def set_organizations
    @organizations ||= current_user.organizations
  end

  def organization_params
    params.require(:organization).permit(:name)
  end
end
