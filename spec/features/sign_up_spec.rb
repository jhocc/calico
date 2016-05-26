require 'rails_helper'

feature 'Sign up' do
  scenario 'user clicks sign up link on home page' do
    visit root_path
    click_link 'Sign Up'
    expect(page).to have_content 'First Name'
    expect(page).to have_content 'Email Address'
    expect(page).to have_content 'Zip Code'
    expect(page).to have_button('Upload Profile Picture', disabled: true)
    expect(page).to have_button 'Save'
  end

  scenario 'user signs up' do
    visit root_path
    click_link 'Sign Up'
    fill_in 'user[first_name]', with: 'foo'
    fill_in 'user[last_name]', with: 'baz'
    fill_in 'user[email]', with: 'foo.baz@test.com'
    fill_in 'user[phone]', with: '9177187777'
    fill_in 'user[addresses][street_address]', with: '14 main st'
    fill_in 'user[addresses][city]', with: 'Brooklyn'
    select 'New York', from: 'user[addresses][state]'
    fill_in 'user[addresses][zip_code]', with: '10010'
    fill_in 'user[password]', with: 'Password123'
    fill_in 'user[password_confirmation]', with: 'Password123'
    click_button 'Save'

    expect(page).to have_content 'Dashboard'
    expect(page).to have_content 'Sign Out'

    click_link 'My Profile'
    expect(page).to have_content 'foo baz'
    expect(page).to have_content '14 main st'
    expect(page).to have_content '9177187777'
  end
end
