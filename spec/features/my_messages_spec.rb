require 'rails_helper'

feature 'my messages' do
  scenario 'user can see a list of other users who have messaged them' do
    user_myself = FactoryGirl.create(:user, first_name: 'Me', last_name: 'And Myself')

    philip_fry = FactoryGirl.create(:user, first_name: 'Phillip', last_name: 'Fry')
    turanga_leela = FactoryGirl.create(:user, first_name: 'Turanga', last_name: 'Leela')
    bender_rodriguez = FactoryGirl.create(:user, first_name: 'Bender', last_name: 'Rodriguez')

    login_as user_myself

    [philip_fry, turanga_leela, bender_rodriguez].each do |other_user|
      FactoryGirl.create(:channel, users: [other_user, user_myself])
    end

    visit root_path
    click_link 'My Messages'

    expect(page).to have_content 'Phillip Fry'
    expect(page).to have_content 'Turanga Leela'
    expect(page).to have_content 'Bender Rodriguez'
    expect(page).to_not have_content 'Me And Myself'
  end
end
