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
    role.memberships.create(role:, organization:)
  end

  describe 'GET /show' do
    context 'with a logged in user', authenticated_as: :user do
      before { get organization_url(organization) }

      it 'respond with a success status' do
        # debugger
        expect(response).to have_http_status(:success)
      end

      it 'renders an show page' do
        expect(response).to render_template(:show)
      end
    end

    context 'with a guest' do
      before { get organization_url(user) }

      it_behaves_like 'an unauthorised user'
    end
  end

  # describe 'GET /new' do
  #   it 'returns http success' do
  #     get '/organizations/new'
  #     expect(response).to have_http_status(:success)
  #   end
  # end

  # describe 'GET /index' do
  #   it 'returns http success' do
  #     get '/organizations/index'
  #     expect(response).to have_http_status(:success)
  #   end
  # end

  # describe 'GET /edit' do
  #   it 'returns http success' do
  #     get '/organizations/edit'
  #     expect(response).to have_http_status(:success)
  #   end
  # end
end
