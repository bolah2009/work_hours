module WorkHoursSpecSupportRequest
  # Parses the response.body as JSON.
  #
  # @example
  #  json_response

  # @example
  #  json_response.is_a?(Array)
  #
  # @return [Array, Hash, ...] Parsed JSON structure as Ruby object
  def json_response
    JSON.parse(response.body)
  end

  # Authenticates all requests of the current example as the given user.
  #
  # @example
  #  authenticated_as(some_admin_user)
  #
  # @example
  #  authenticated_as(some_admin_user, on_behalf_of: customer_user)
  #
  # @example
  #  authenticated_as(some_admin_user, password: 'wrongpw')
  #
  # @example
  #  authenticated_as(nil, email: 'not_existing', password: 'wrongpw' )
  #
  # @return nil
  def authenticated_as(user, **options)
    password = options[:password] || user.password.to_s
    email = options[:email] || user.email

    post '/sign_in', params: { email:, password: }
  end
end

RSpec.configure do |config|
  config.include WorkHoursSpecSupportRequest, type: :request

  # This helper allows you to authenticate as a given user in request specs
  # via the example metadata, rather than directly:
  #
  #     it 'does something', authenticated_as: :user
  #
  # In order for this to work, you must define the user in a `let` block first:
  #
  #     let(:user) { create(:user) }
  #
  config.before(:each, :authenticated_as, type: :request) do |example|
    user = authenticated_as_get_user example.metadata[:authenticated_as], return_type: :user

    authenticated_as user if user
  end
end
