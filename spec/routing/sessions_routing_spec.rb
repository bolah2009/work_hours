require 'rails_helper'

RSpec.describe SessionsController do
  describe 'routing' do
    it 'routes to #new' do
      expect(get: '/sign_in').to route_to('sessions#new')
    end

    it 'routes to #create' do
      expect(post: '/sign_in').to route_to('sessions#create')
    end

    it 'routes to #destroy' do
      expect(get: '/logout').to route_to('sessions#destroy')
    end
  end
end
