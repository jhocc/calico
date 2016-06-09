require 'rails_helper'

feature 'Sign up' do
  scenario 'user clicks sign up link on home page' do
    visit root_path
    click_link 'Create New Account'
    expect(page).to have_content 'First Name'
    expect(page).to have_content 'Email Address'
    expect(page).to have_content 'Zip Code'
    # expect(page).to have_button('Upload Profile Picture', disabled: true)
    expect(page).to have_button 'Save'
  end

  scenario 'user signs up' do
    visit root_path
    click_link 'Create New Account'
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

    click_menu_link 'My Profile'

    expect(find_field('First Name').value).to eq 'foo'
    expect(find_field('Last Name').value).to eq 'baz'
    expect(find_field('Street Address').value).to eq '14 main st'
    expect(find_field('Phone').value).to eq '9177187777'
  end

  scenario 'requires first_name and last_name' do
    visit root_path
    click_link 'Create New Account'
    fill_in 'Email Address', with: 'foo.baz@test.com'
    fill_in 'Zip Code', with: '10010'
    fill_in 'user_password', with: 'Password123'
    fill_in 'user_password_confirmation', with: 'Password123'

    click_button 'Save'

    expect(page).to have_content("First name can't be blank")
    expect(page).to have_content("Last name can't be blank")

    fill_in 'First Name', with: 'foo'
    fill_in 'Last Name', with: 'baz'
    fill_in 'Zip Code', with: '10010'
    fill_in 'user_password', with: 'Password123'
    fill_in 'user_password_confirmation', with: 'Password123'

    click_button 'Save'

    click_menu_link 'My Profile'

    expect(find_field('First Name').value).to eq 'foo'
    expect(find_field('Last Name').value).to eq 'baz'
  end

  scenario 'upload profile photo' do
    visit root_path
    click_link 'Create New Account'

    fill_in 'Email Address', with: 'foo.baz@test.com'
    fill_in 'Zip Code', with: '10010'
    fill_in 'First Name', with: 'foo'
    fill_in 'Last Name', with: 'baz'
    fill_in 'user_password', with: 'Password123'
    fill_in 'user_password_confirmation', with: 'Password123'

    profile_photo =  File.open(File.join(Rails.root, 'spec/support/assets/cc.png'))
    attach_file 'user_profile_photo', profile_photo.path

    click_button 'Save'

    click_menu_link 'My Profile'

    user = User.find_by(email: 'foo.baz@test.com')
    expect(page).to have_css("img[src='#{user.profile_photo.large.url}']")
  end
end
