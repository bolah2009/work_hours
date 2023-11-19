shared_examples 'a record not found error' do
  it 'respond with a not found status' do
    expect(response).to have_http_status(:not_found)
  end

  it 'renders home page' do
    expect(response.body).to include 'redirected'
  end
end
