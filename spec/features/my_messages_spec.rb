require 'rails_helper'

feature 'my messages' do
  scenario 'user can see an initial message from Calico Feedback user after sign up' do
    visit root_path
    click_link 'Sign Up'
    fill_in 'First Name', with: 'foo'
    fill_in 'Last Name', with: 'baz'
    fill_in 'Email Address', with: 'foo.baz@test.com'
    fill_in 'Phone', with: '9177187777'
    fill_in 'Street Address', with: '14 main st'
    fill_in 'City', with: 'Brooklyn'
    select 'New York', from: 'State'
    fill_in 'Zip Code', with: '10010'
    fill_in 'user_password', with: 'Password123'
    fill_in 'user_password_confirmation', with: 'Password123'
    click_button 'Save'

    visit channels_path

    expect(page).to have_content 'Calico Feedback User'
    expect(page).to_not have_content 'Me And Myself'

    within '.message-window' do
      expect(page).to have_content 'Hi there!'
      expect(page).to have_content 'Calico Feedback User'
    end

    expect(page).to have_button 'Send'
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

    visit channels_path

    expect(page).to have_content 'Phillip Fry'
    expect(page).to have_content 'Turanga Leela'
    expect(page).to have_content 'Bender Rodriguez'
    expect(page).to_not have_content 'Me And Myself'
  end

  scenario 'user can see a conversation header' do
    user_myself = FactoryGirl.create(:user, first_name: 'Me', last_name: 'And Myself')
    finn_the_human = FactoryGirl.create(:user, first_name: 'Finn', last_name: 'Mertens')
    princess_bubblegum = FactoryGirl.create(:user, first_name: 'Princess', last_name: 'Bubblegum')
    FactoryGirl.create(:channel, users: [finn_the_human, user_myself])
    FactoryGirl.create(:channel, users: [princess_bubblegum, user_myself])

    login_as user_myself

    visit channels_path
    expect(page).to have_content 'Conversation with Finn Mertens'

    click_on('Princess Bubblegum')
    expect(page).to have_content 'Conversation with Princess Bubblegum'
  end

  scenario 'user can see a list of messages in a selected channel' do
    user_myself = FactoryGirl.create(:user, first_name: 'Me', last_name: 'And Myself')
    finn_the_human = FactoryGirl.create(:user, first_name: 'Finn', last_name: 'Mertens')
    princess_bubblegum = FactoryGirl.create(:user, first_name: 'Princess', last_name: 'Bubblegum')
    message_from_finn = FactoryGirl.build(:message, content: 'Is that Jake?', user: finn_the_human)
    message_from_bubblegum = FactoryGirl.build(
      :message,
      content: 'Get outta here varmints',
      user: princess_bubblegum
    )

    FactoryGirl.create(
      :channel,
      messages: [message_from_finn],
      users: [finn_the_human, user_myself]
    )
    FactoryGirl.create(
      :channel,
      messages: [message_from_bubblegum],
      users: [princess_bubblegum, user_myself]
    )

    login_as user_myself
    visit channels_path

    click_on 'Finn Mertens'
    expect(page).to have_content 'Is that Jake?'

    click_on 'Princess Bubblegum'
    expect(page).to have_content 'Get outta here varmints'
  end

  scenario 'user can send messages in their available user channels' do
    user_myself = FactoryGirl.create(:user, first_name: 'Me', last_name: 'And Myself')
    finn_the_human = FactoryGirl.create(:user, first_name: 'Finn', last_name: 'Mertens')
    FactoryGirl.create(:channel, users: [finn_the_human, user_myself])

    login_as user_myself
    visit channels_path

    click_on 'Finn Mertens'

    fill_in 'message-input', with: 'a new message'
    click_on 'Send'

    within '.message-window' do
     expect(page).to have_content 'a new message'
    end
  end
end
