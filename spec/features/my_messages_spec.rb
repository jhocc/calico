require 'rails_helper'

feature 'my messages' do
  scenario 'user can see a channel open with the help user' do
    user_myself = FactoryGirl.create(:user, first_name: 'Me', last_name: 'And Myself')
    login_as user_myself

    visit messages_path

    expect(page).to have_content 'Help User'
    expect(page).to_not have_content 'Me And Myself'
  end

  scenario 'user can see a list of other users who have messaged them' do
    user_myself = FactoryGirl.create(:user, first_name: 'Me', last_name: 'And Myself')

    phillip_fry = FactoryGirl.create(:user, first_name: 'Phillip', last_name: 'Fry')
    turanga_leela = FactoryGirl.create(:user, first_name: 'Turanga', last_name: 'Leela')
    bender_rodriguez = FactoryGirl.create(:user, first_name: 'Bender', last_name: 'Rodriguez')

    login_as user_myself

    [phillip_fry, turanga_leela, bender_rodriguez].each do |other_user|
      FactoryGirl.create(:channel, users: [other_user, user_myself])
    end

    visit messages_path

    expect(page).to have_content 'Help User'
    expect(page).to have_content 'Phillip Fry'
    expect(page).to have_content 'Turanga Leela'
    expect(page).to have_content 'Bender Rodriguez'
    expect(page).to_not have_content 'Me And Myself'
  end

  scenario 'user can see a conversation header' do
    user_myself = FactoryGirl.create(:user, first_name: 'Me', last_name: 'And Myself')
    finn_the_human = FactoryGirl.create(:user, first_name: 'Finn', last_name: 'Mertens')
    FactoryGirl.create(:channel, users: [finn_the_human, user_myself])

    login_as user_myself

    visit messages_path
    expect(page).to have_content 'Conversation with Help User'

    click_on('Finn Mertens')
    expect(page).to have_content 'Conversation with Finn Mertens'
  end
end
