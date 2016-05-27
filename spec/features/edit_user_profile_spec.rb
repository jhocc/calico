require 'rails_helper'

feature 'Edit user profile' do
  scenario 'User can edit thier profile' do
    user = FactoryGirl.create(:user,
                              first_name: 'john',
                              last_name: 'doe',
                              email: 'test@casecommons.org',
                              password: '123456',
                              password_confirmation: '123456')
    user.addresses << FactoryGirl.create(:address)
    user.save

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
end
