require 'rails_helper'
require_relative '../support/shared_examples/unauthorised_user'
require 'debug'

RSpec.describe '/users' do
  let(:valid_attributes) do
    attributes_for(:user)
  end

  let(:invalid_attributes) do
    attributes_for(:user, name: nil)
  end

  let(:user) { create(:user) }
  let(:user_two) { create(:user) }
  let(:organization) { create(:organization) }
  let(:role) { admin_role }
  let(:admin_role) { create(:role, name: 'admin') }
  let(:owner_role) { create(:role, name: 'owner') }
  let(:member_role) { create(:role, name: 'member') }

  describe 'GET /show' do
    let(:user_to_show) { user }

    context 'with a logged in user', authenticated_as: :user do
      before do
        user.memberships.create!(role:, organization:)
        user_two.memberships.create!(role: member_role, organization:)
        start_time = Time.zone.now.beginning_of_day + 1.hour
        end_time = Time.zone.now.beginning_of_day + 9.hours
        organization.metrics.create!(user: user_two, date: 1.day.ago, start_time:, end_time:)
        organization.metrics.create!(user:, date: 1.day.ago, start_time:, end_time:)
        get organization_user_url(organization, user_to_show)
      end

      it 'respond with a success status' do
        expect(response).to have_http_status(:success)
      end

      it 'renders an show page' do
        expect(response).to render_template(:show)
      end

      context 'when an admin tries to show another user metrics' do
        let(:role) { admin_role }
        let(:user_to_show) { user_two }

        it 'shows the user metrics' do
          expect(assigns(:metrics)).to be_any do |_date, metrics|
            metrics.any? do |metric|
              metric.user_id == user_two.id
            end
          end
        end
      end

      context 'when an owner tries to show another user metrics' do
        let(:role) { owner_role }
        let(:user_to_show) { user_two }

        it 'shows the user metrics' do
          expect(assigns(:metrics)).to be_any do |_date, metrics|
            metrics.any? do |metric|
              metric.user_id == user_two.id
            end
          end
        end
      end

      context 'when a member tries to show another user metrics' do
        let(:role) { member_role }
        let(:user_to_show) { user_two }

        it 'does not show the user metrics' do
          expect(assigns(:metrics)).not_to be_any do |_date, metrics|
            metrics.any? do |metric|
              metric.user_id == user_two.id
            end
          end
        end
      end
    end

    context 'with a guest' do
      before { get organization_user_url(organization, user) }

      it_behaves_like 'an unauthorised user'
    end
  end

  describe 'GET /new' do
    before { get new_user_url }

    it 'renders a successful response' do
      expect(response).to be_successful
    end

    it 'renders new account page' do
      expect(response.body).to render_template :new
    end

    context 'with a logged in user', authenticated_as: :user do
      it 'respond with a redirect status' do
        expect(response).to have_http_status(:redirect)
      end

      it 'prevents signed in user from re-registration' do
        expect(response).to redirect_to(root_url)
      end
    end
  end

  describe 'GET /edit' do
    let(:user_to_edit) { user }

    before { get edit_user_url(user_to_edit) }

    context 'with a logged in user', authenticated_as: :user do
      it 'respond with a success status' do
        expect(response).to have_http_status(:success)
      end

      it 'renders an show page' do
        expect(response).to render_template(:edit)
      end

      context 'when user tries to edit another user' do
        let(:user_to_edit) { user_two }

        it 'respond with a redirect status' do
          expect(response).to have_http_status(:redirect)
        end

        it 'redirects user to the root path' do
          expect(response).to redirect_to(root_url)
        end
      end
    end

    context 'with a guest' do
      before { get organization_user_url(organization, user) }

      it_behaves_like 'an unauthorised user'
    end
  end

  describe 'POST /create' do
    context 'with valid parameters' do
      it 'creates a new User' do
        expect do
          post users_url, params: { user: valid_attributes }
        end.to change(User, :count).by(1)
      end

      it 'renders the user page' do
        post users_url, params: { user: valid_attributes }
        expect(response).to redirect_to(root_url)
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new User' do
        expect do
          post users_url, params: { user: invalid_attributes }
        end.not_to change(User, :count)
      end

      it 'respond with a unprocessable entity status' do
        post users_url, params: { user: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
