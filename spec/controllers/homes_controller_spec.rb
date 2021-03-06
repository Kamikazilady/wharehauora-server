require 'rails_helper'
# rubocop:disable Rails/HttpPositionalArguments
RSpec.describe HomesController, type: :controller do
  include Devise::Test::ControllerHelpers

  let(:user) { FactoryGirl.create(:user) }
  let(:home) { FactoryGirl.create(:home, owner_id: user.id) }
  let(:another_home) { FactoryGirl.create(:home, name: "someone else's home") }
  let(:public_home)  { FactoryGirl.create(:home, name: 'public home', is_public: true) }

  context 'not signed in ' do
    describe 'GET show for a public home' do
      before { get :show, id: public_home.to_param }
      it { expect(response).to have_http_status(:success) }
    end

    describe 'GET show for a private home' do
      before { get :show, id: another_home.to_param }
      it { expect(response).to have_http_status(:not_found) }
    end

    describe 'GET edit for a home' do
      before { get :edit, id: home.to_param }
      it { expect(response).to redirect_to(new_user_session_path) }
    end
  end

  context 'user is signed in' do
    before { sign_in user }

    describe 'GET show' do
      describe 'no sensors' do
        before { get :show, id: home.id }
        it { expect(response).to have_http_status(:success) }
      end
      describe 'lots of sensors' do
        before do
          15.times { FactoryGirl.create(:sensor, home: home) }
          get :show, id: home.id
        end
        it { expect(response).to have_http_status(:success) }
      end

      describe "someone else's home" do
        before { get :show, id: another_home.id }
        it { expect(response).to have_http_status(:not_found) }
      end

      describe 'public home' do
        before { get :show, id: public_home.id }
        it { expect(response).to have_http_status(:success) }
      end
    end
    describe '#update' do
      before { patch :update, id: home.to_param, home: { name: 'New home name' } }
      it { expect(response).to redirect_to(home) }
    end

    describe "GET edit for someone else's home" do
      before { get :edit, id: another_home.to_param }
      it { expect(response).to have_http_status(:not_found) }
    end
  end # end signed in
end
