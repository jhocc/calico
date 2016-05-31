require 'rails_helper'

feature 'Resources index page' do
  let(:user) { FactoryGirl.create(:user_with_addresses) }
  let(:zip_code) { user.primary_address.zip_code }

  scenario 'include only resources for the user zip code' do
    response = [
      {
        "facility_address" => "1727 MARTIN LUTHER KING WY#109",
        "facility_name" => "FAMILYPATHS, INC.",
        "facility_state" => "CA",
        "facility_city" => "OAKLAND",
        "facility_status" => "LICENSED",
        "facility_telephone_number" => "(510) 893-9230",
        "facility_type" => "FOSTER FAMILY AGENCY",
        "facility_zip" => "94612",
      }, {
        "facility_address" => "9998 CROW CANYON ROAD",
        "facility_name" => "HOSANNA PATHWAYS",
        "facility_state" => "CA",
        "facility_city" => "CASTRO VALLEY",
        "facility_status" => "LICENSED",
        "facility_telephone_number" => "(510) 538-8117",
        "facility_type" => "FOSTER FAMILY AGENCY SUB",
        "facility_zip" => "94612",
      }, {
        "facility_address" => "522 GRAND AVE.",
        "facility_name" => "AMERICAN INDIAN CHILD RESOURCE CENTER FFA",
        "facility_state" => "CA",
        "facility_city" => "OAKLAND",
        "facility_status" => "LICENSED",
        "facility_telephone_number" => "(510) 208-1870",
        "facility_type" => "FOSTER FAMILY AGENCY",
        "facility_zip" => "94612",
      }
    ].map do |hash|
      Hashie::Mash.new(hash)
    end

    expect_any_instance_of(SODA::Client).to receive(:get).and_return(response)

    login_as user
    visit resources_path

    expect(page).to have_content("Foster Family Agencies in #{zip_code}")

    expect(page).to have_content('FAMILYPATHS, INC')
    expect(page).to have_content('1727 MARTIN LUTHER KING WY#109, OAKLAND, CA 94612')
    expect(page).to have_content('(510) 893-9230')

    expect(page).to have_content('HOSANNA PATHWAYS')
    expect(page).to have_content('9998 CROW CANYON ROAD, CASTRO VALLEY, CA 94612')
    expect(page).to have_content('(510) 538-8117')
  end
end
