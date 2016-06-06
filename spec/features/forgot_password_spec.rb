require 'rails_helper'

feature 'Forgot password' do
  scenario 'user can request for new password' do
    user = FactoryGirl.create(:user, email: 'test@casecommons.org')
    visit root_path
    click_link 'Forgot your password?'
    expect(page).to have_content "Forgot your password? Enter your email below and we'll email instructions on how to reset your password."
    expect(page).to have_field 'Email Address'
    expect(page).to have_button 'Send Password Reset Instructions'

    fill_in 'Email Address', with: user.email
    click_button 'Send Password Reset Instructions'

    expect(page).to have_content('If you are an existing Calico user, you will get an email with a link to create a new password momentarily.  Please click on that link and follow the instructions to change your password and login.')

    mail = ActionMailer::Base.deliveries.first.body
    expect(mail).to include(user.email)
    expect(mail).to include('Someone has requested a link to change your password')

    visit edit_user_password_path(user, reset_password_token: user.reload.reset_password_token)

    expect(page).to have_content('Reset your password')
  end
end
