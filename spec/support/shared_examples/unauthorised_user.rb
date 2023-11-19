shared_examples 'an unauthorised user' do
  it 'respond with a redirect status' do
    expect(response).to have_http_status(:redirect)
  end

  it 'redirects to sign in page' do
    expect(response).to redirect_to(sign_in_url)
  end

  it 'renders sign in page' do
    follow_redirect!
    expect(response.body).to render_template('sessions/new')
  end

  it 'renders sign in form' do
    follow_redirect!
    expect(response.body).to match(/Enter your email and password/)
  end
end
