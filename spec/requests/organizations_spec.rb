require 'rails_helper'
require_relative '../support/shared_examples/unauthorised_user'

RSpec.describe 'Organizations' do
  let(:valid_attributes) do
    attributes_for(:organization)
  end

  let(:invalid_attributes) do
    attributes_for(:organization, name: nil)
  end

  let(:user) { create(:user) }
  let(:organization) { create(:organization) }
  let(:role) { create(:role, name: 'owner') }

  before do
    user.memberships.create(role:, organization:)
  end

  describe 'GET /show' do
    before { get organization_url(organization) }

    context 'with a logged in user', authenticated_as: :user do
      it 'respond with a success status' do
        expect(response).to have_http_status(:success)
      end

      it 'renders an show page' do
        expect(response).to render_template(:show)
      end
    end

    context 'with a guest' do
      it_behaves_like 'an unauthorised user'
    end
  end

  describe 'GET /new' do
    before { get new_organization_url }

    context 'with a logged in user', authenticated_as: :user do
      it 'respond with a success status' do
        expect(response).to have_http_status(:success)
      end

      it 'renders an show page' do
        expect(response).to render_template(:new)
      end
    end

    context 'with a guest' do
      it_behaves_like 'an unauthorised user'
    end
  end

  describe 'POST /create' do
    context 'with a logged in user', authenticated_as: :user do
      context 'with valid parameters' do
        it 'creates a new organization' do
          expect do
            post organizations_url, params: { organization: valid_attributes }
          end.to change(Organization, :count).by(1)
        end

        it 'renders the organization page' do
          post organizations_url, params: { organization: valid_attributes }
          expect(response).to render_template(:index)
        end
      end

      context 'with invalid parameters' do
        it 'does not create a new organization' do
          expect do
            post organizations_url, params: { organization: invalid_attributes }
          end.not_to change(User, :count)
        end

        it 'respond with a unprocessable entity status' do
          post organizations_url, params: { organization: invalid_attributes }
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    context 'with a guest' do
      before do
        post organizations_url, params: { user: valid_attributes }
      end

      it_behaves_like 'an unauthorised user'
    end
  end
end
