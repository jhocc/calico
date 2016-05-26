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
    fill_in 'First Name', with: 'foo'
    fill_in 'Last Name', with: 'baz'
    fill_in 'Email Address', with: 'foo.baz@test.com'
    fill_in 'Phone', with: '9177187777'
    fill_in 'Street Address', with: '14 main st'
    fill_in 'City', with: 'Brooklyn'
    select 'New York', from: 'State'
    fill_in 'Zip Code', with: '10010'
    fill_in 'Password', with: 'Password123'
    fill_in 'Password Confirmation', with: 'Password123'
    click_button 'Save'

    expect(page).to have_content 'Dashboard'
    expect(page).to have_content 'Sign Out'

    click_link 'My Profile'
    expect(page).to have_content 'foo baz'
    expect(page).to have_content '14 main st'
    expect(page).to have_content '9177187777'
  end
end
