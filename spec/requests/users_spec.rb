require 'rails_helper'
require_relative '../support/shared_examples/unauthorised_user'

RSpec.describe '/users' do
  let(:valid_attributes) do
    attributes_for(:user)
  end

  let(:invalid_attributes) do
    attributes_for(:user, name: nil)
  end

  let(:user) { create(:user) }
  let(:organization) { create(:organization) }
  let(:role) { create(:role, name: 'admin') }

  describe 'GET /show' do
    context 'with a logged in user', authenticated_as: :user do
      before do
        user.memberships.create!(role:, organization:)
        get organization_user_url(organization, user)
      end

      it 'respond with a success status' do
        expect(response).to have_http_status(:success)
      end

      it 'renders an show page' do
        expect(response).to render_template(:show)
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

  describe 'POST /create' do
    context 'with valid parameters' do
      it 'creates a new User' do
        expect do
          post users_url, params: { user: valid_attributes }
        end.to change(User, :count).by(1)
      end

      it 'renders a successful response' do
        post users_url, params: { user: valid_attributes }
        expect(response).to be_successful
      end

      it 'renders the user page' do
        post users_url, params: { user: valid_attributes }
        expect(response).to render_template(:show)
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

  describe 'PATCH /update' do
    before do
      patch user_url(user_param), params: { user: attributes }
    end

    let(:user) { create(:user) }
    let(:user_param) { user }
    let(:attributes) { { name: 'Bola', email: 'another_email@example.com' } }

    context 'with valid parameters' do
      context 'with a logged in user', authenticated_as: :user do
        it 'updates the requested user' do
          expect(user.reload.name).to eq(attributes[:name])
        end

        it 'does not update unpermitted params - email' do
          expect(user.reload.email).not_to eq(attributes[:email])
        end

        it 'returns a successful response' do
          expect(response).to be_successful
        end

        context 'when on a diffrent user page' do
          let(:user_param) { create(:user) }

          it 'redirects' do
            expect(response).to have_http_status(:redirect)
          end

          it 'redirects to user page' do
            expect(response).to redirect_to root_url
          end

          it 'does not update the requested user' do
            expect(user.reload.name).not_to eq(attributes[:name])
          end
        end
      end

      context 'with a guest' do
        it_behaves_like 'an unauthorised user'
      end
    end

    context 'with invalid parameters', authenticated_as: :user do
      let(:attributes) { { name: nil } }

      it 'renders a unprocessable entity response' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'does not update the requested user' do
        expect(user.reload.name).not_to eq(attributes[:name])
      end
    end
  end
end
