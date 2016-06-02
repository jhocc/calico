require 'rails_helper'

feature 'drawer' do
  let(:user) { FactoryGirl.create(:user_with_addresses) }

  context 'when user is logged in' do
    before do
      login_as user
    end

    scenario 'go to My Messages' do
      visit edit_user_registration_path
      click_menu_link 'My Messages'

      expect(current_path).to eq root_path
    end

    scenario 'go to Resource Finder' do
      visit root_path
      click_menu_link 'Resource Finder'

      expect(current_path).to eq foster_family_agencies_path
    end

    scenario 'go to My Profile' do
      visit root_path
      click_menu_link 'My Profile'

      expect(current_path).to eq edit_user_registration_path
    end

    scenario 'user logout' do
      visit root_path
      click_menu_link 'Log Out'

      expect(current_path).to eq new_user_session_path
    end
  end

  context 'when user is not logged in' do
    scenario 'no menu icon available' do
      visit root_path

      expect(page).to_not have_selector('.menu-icon')
    end
  end
end
