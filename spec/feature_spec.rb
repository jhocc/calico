require 'rails_helper'

feature 'test feature' do
  scenario 'load the page' do
    visit '/'
    expect(page).to have_content 'Hello Casebook'
  end
end
