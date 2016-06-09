require 'rails_helper'

feature 'Sign in' do
  let(:user) { FactoryGirl.create(:user_with_addresses) }
  scenario 'user chooses sign in from home page' do
    visit root_path

    expect(page).to_not have_css('#error_explanation')

    fill_in 'user[email]', with: user.email
    fill_in 'user[password]', with: 'Password123'
    click_button 'Sign In'
    expect(current_path).to eq root_path
  end

  scenario 'user sign outs' do
    visit root_path
    fill_in 'user[email]', with: user.email
    fill_in 'user[password]', with: 'Password123'
    click_button 'Sign In'
    click_menu_link 'Log Out'

    expect(page).to have_link 'Create New Account'
    expect(page).to have_button 'Sign In'
  end
end
