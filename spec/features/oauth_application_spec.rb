require 'rails_helper'

RSpec.feature 'OAuth Applications', type: :feature do
  let(:janitor) { FactoryGirl.create(:user, :janitor_user) }
  let(:user) { FactoryGirl.create(:user) }

  # let!(:oauth_applications) { FactoryGirl.create_list(:indicator, 5) }
  # let(:indicator) { FactoryGirl.create(:indicator) }
  let(:our_user) { false }
  before { login_as(our_user) if our_user }

  shared_examples 'not_authorized' do
    it { expect(page).to have_content('You are not authorized to perform this action') }
  end

  shared_examples 'show_login' do
    it { expect(page).to have_field('Password') }
  end

  describe 'index page' do
    before { visit oauth_applications_path }
    context 'when logged in as janitor' do
      let(:our_user) { janitor }
      #     it { expect_index_page }
      it { expect(page).to have_content('New Application') }
    end

    context 'when logged in as normal user' do
      let(:our_user) { user }
      pending { expect(page).not_to have_link('New Application') }
      # include_examples 'show_login'
    end

    context 'anonymous' do
      it { expect(page).not_to have_link('New Application') }
      include_examples 'show_login'
    end
  end
end
