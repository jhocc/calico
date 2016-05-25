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
end
