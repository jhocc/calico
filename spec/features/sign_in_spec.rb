require 'rails_helper'

feature 'Sign in' do
  scenario 'user chooses sign in from home page' do
    visit root_path
    user = FactoryGirl.create(:user)
    fill_in 'user[email]', with: user.email
    fill_in 'user[password]', with: 'Password123'
    click_button 'Sign In'
    expect(page).to have_content 'Dashboard'
  end

  scenario 'user sign outs' do
    visit root_path
    user = FactoryGirl.create(:user)
    fill_in 'user[email]', with: user.email
    fill_in 'user[password]', with: 'Password123'
    click_button 'Sign In'
    click_menu_link 'Log Out'

    expect(page).to have_link 'Sign Up'
    expect(page).to have_button 'Sign In'
  end
end
