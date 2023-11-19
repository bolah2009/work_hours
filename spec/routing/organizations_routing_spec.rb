require 'rails_helper'

RSpec.describe 'OrganizationsController' do
  describe 'routing' do
    it 'routes to #show' do
      expect(get: '/organizations/1').to route_to('organizations#show', id: '1')
    end

    it 'routes to #new' do
      expect(get: '/organizations/new').to route_to('organizations#new')
    end

    it 'routes to #index' do
      expect(get: '/organizations').to route_to('organizations#index')
    end

    it 'routes to #create' do
      expect(post: '/organizations').to route_to('organizations#create')
    end
  end
end
