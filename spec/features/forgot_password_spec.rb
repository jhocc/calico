require 'rails_helper'

feature 'Forgot password' do
  scenario 'user can request for new password' do
    user = FactoryGirl.create(:user, email: 'test@casecommons.org')
    visit root_path
    click_link 'Forgot your password?'
    expect(page).to have_content "Can't remember your password?  No problem, just enter your email and we will send you a new one!"
    expect(page).to have_field 'Email Address'
    expect(page).to have_button 'Send me reset password instructions'


    fill_in 'Email Address', with: user.email
    click_button 'Send me reset password instructions'

    mail = ActionMailer::Base.deliveries.first.body
    expect(mail).to include(user.email)
    expect(mail).to include('Someone has requested a link to change your password')

    visit edit_user_password_path(user, reset_password_token: user.reload.reset_password_token)

    expect(page).to have_content('Change your password')
  end
end
