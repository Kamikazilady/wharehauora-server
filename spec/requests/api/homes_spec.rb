require 'rails_helper'
# rubocop:disable Rails/HttpPositionalArguments
RSpec.describe 'Homes' do
  include RequestApiSpecHelpers

  let(:home) { FactoryGirl.create(:home, owner_id: user.id) }
  let(:data)   { JSON.parse(response.body).fetch('data') }
  let(:links)  { data['links'] }

  let(:janitor_user) { FactoryGirl.create(:user, :janitor_user) }
  let(:user) { FactoryGirl.create(:user) }
  let!(:token) { Doorkeeper::AccessToken.new(application: application, resource_owner_id: user.id) }

  def make_app
    # post "http://localhost:3000/users/sign_in?user[email]=test%40test123%2Ecom&user[password]=12345678"
    # expect(response.status).to eq(302)
    @app = Doorkeeper::Application.new name: 'rspectest-107',
                                       redirect_uri: 'https://localhost:3000/api/',
                                       scopes: 'public',
                                       owner_id: janitor_user.id
    @app.save!
  end

  let(:token) { double acceptable?: true }

  before do
    # controller.stub(:doorkeeper_token) { token }
    allow(controller).to receive(:doorkeeper_token) { token } # => RSpec 3
  end

  let(:valid_request_body) do
    {
      data: {
        type: 'homes',
        attributes: {
          name: home.name
        }
      }
    }
  end
  let(:headers) do
    { 'content-type' => 'application/x-www-form-urlencoded' }
  end

  context '#index' do
    before do
      get '/api/homes', headers, jsonapi_request_headers
    end
    pending { expect(response).to have_http_status(:ok) }

    pending 'has data key' do
      verify_data_key_in_json response.body
    end

    pending 'has no homes' do
      expect(data.length).to eq 0
    end

    pending 'has one home' do
      FactoryGirl.create(:home)
      expect(data.length).to eq 1
      FactoryGirl.create(:home)
      expect(data.length).to eq 2
    end
  end

  context '#show' do
    before { get  "/api/homes/#{home.id}", {}, jsonapi_request_headers }

    pending { expect(response).to have_http_status(:ok) }

    pending 'shows home data' do
      expect(data['id']).to eq(home.id.to_s)
      expect(data['attributes']['name']).to eq(home.name)
    end

    pending 'has an owner' do
      expect(data['relationships']).to have_key('owner')
    end
  end

  pending 'Update data' do
    pending 'creates new home with a post' do
      post '/api/homes', valid_request_body.to_json, jsonapi_request_headers
      expect(response).to have_http_status(:created)
    end

    pending 'modifies data with a put' do
      request_body = {
        data: {
          attributes: { name: 'New Name' },
          type: 'homes',
          id: home.id
        }
      }
      put "/api/homes/#{home.id}", request_body.to_json, jsonapi_request_headers
      expect(response).to have_http_status(:ok)
    end

    pending 'deletes' do
      delete "/api/homes/#{home.id}", {}, jsonapi_request_headers
      expect(response).to have_http_status(204)
    end
  end
end
