require 'rails_helper'

feature 'home page' do
  scenario 'user see option to sign in and sign up' do
    visit root_path
    expect(page).to have_button 'Sign in'
    expect(page).to have_link 'Sign up'
    expect(page).to have_content 'Email'
    expect(page).to have_content 'Password'
  end
end
