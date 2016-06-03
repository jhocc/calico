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

    click_menu_link 'My Profile'

    expect(page).to have_button 'Update'

    fill_in 'First Name', with: 'Johnny'
    fill_in 'Street Address', with: 'Localhost 34th street'
    fill_in 'Zip Code', with: '10010'

    click_button 'Update'

    click_menu_link 'My Profile'

    expect(find_field('First Name').value).to eq 'Johnny'
    expect(find_field('Street Address').value).to eq 'Localhost 34th street'
  end

  scenario 'requires first_name and last_name' do
    login_as user

    visit root_path

    click_menu_link 'My Profile'

    fill_in 'First Name', with: ''
    fill_in 'Last Name', with: ''

    click_button 'Update'

    expect(page).to have_content('errors')

    fill_in 'First Name', with: 'foobar'
    fill_in 'Last Name', with: 'bazqaz'

    click_button 'Update'

    click_menu_link 'My Profile'

    expect(find_field('First Name').value).to eq 'foobar'
    expect(find_field('Last Name').value).to eq 'bazqaz'
  end

  scenario 'User can update password' do
    login_as user

    visit root_path

    click_menu_link 'My Profile'

    expect(page).to have_button 'Update'

    fill_in 'user_password', with: '654321'
    fill_in 'user_password_confirmation', with: '654321'
    fill_in 'user_current_password', with: '123456'

    click_button 'Update'

    click_menu_link 'My Profile'

    expect(find_field('First Name').value).to eq 'john'
    expect(find_field('Last Name').value).to eq 'doe'
  end
end
