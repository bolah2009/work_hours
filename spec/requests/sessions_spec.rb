require 'rails_helper'

RSpec.describe '/sessions' do
  let(:user) { create(:user) }

  describe 'GET /sign_in' do
    before { get sign_in_path }

    context 'with a logged in user', authenticated_as: :user do
      it 'redirects to the root path' do
        expect(response).to redirect_to(:root)
      end
    end

    context 'with a guest' do
      it 'respond with a succesful response' do
        expect(response).to be_successful
      end
    end
  end

  describe 'POST /sign_in' do
    let(:email) { user.email }
    let(:password) { user.password_plain }

    before { post sign_in_path, params: { email:, password: } }

    context 'with a logged in user', authenticated_as: :user do
      it 'redirects to the root path' do
        expect(response).to redirect_to(:root)
      end
    end

    context 'with a guest' do
      it 'respond with a redirect status' do
        expect(response).to have_http_status(:redirect)
      end

      it 'redirects to home page' do
        expect(response).to redirect_to(:root)
      end

      context 'with invalid password' do
        let(:password) { 'wrong password' }

        it 'respond with a unprocessable entity status' do
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end

      context 'with invalid email' do
        let(:email) { 'wrong_email@example.com' }

        it 'respond with a unprocessable entity status' do
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end
  end

  describe 'GET /logout' do
    let(:user) { create(:user) }

    before do
      get logout_path
    end

    context 'with a logged in user', authenticated_as: :user do
      it 'redirects to the root path' do
        expect(response).to redirect_to(:sign_in)
      end
    end

    context 'with a guest' do
      it 'redirects to the root path' do
        expect(response).to redirect_to(:sign_in)
      end
    end
  end
end
