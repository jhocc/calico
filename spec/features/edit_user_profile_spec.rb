require 'rails_helper'

feature 'Edit user profile' do
  let(:user) do
    user = FactoryGirl.create(:user,
                              first_name: 'john',
                              last_name: 'doe',
                              email: 'test@casecommons.org',
                              password: '123456',
                              password_confirmation: '123456')
    user.addresses << FactoryGirl.create(:address)
    user.save
    user
  end

  scenario 'User can edit their profile' do
    login_as user

    visit root_path
    click_link 'Edit My Profile'
    expect(page).to have_button 'Update'

    fill_in 'First Name', with: 'Johnny'
    fill_in 'Street Address', with: 'Localhost 34th street'
    fill_in 'Zip Code', with: '10010'

    click_button 'Update'

    click_link 'My Profile'

    expect(page).to have_content 'Johnny'
    expect(page).to have_content 'Localhost 34th street'
  end

  scenario 'User can update password' do
    login_as user

    visit root_path
    click_link 'Edit My Profile'
    expect(page).to have_button 'Update'

    fill_in 'Password', with: '654321'
    fill_in 'Password Confirmation', with: '654321'
    fill_in 'Current Password', with: '123456'

    click_button 'Update'

    click_link 'My Profile'

    expect(page).to have_content user.first_name
    expect(page).to have_content user.last_name
  end
end
