require 'rails_helper'

feature 'Foster Family Agencies' do
  let(:user) { FactoryGirl.create(:user_with_addresses) }
  let(:zip_code) { user.primary_address.zip_code }

  context 'index page' do
    scenario "display foster family agencies in the user's zip code" do
      response = [
        {
          'facility_address' => '1727 MARTIN LUTHER KING WY#109',
          'facility_name' => 'FAMILYPATHS, INC.',
          'facility_number' => '10707644',
          'facility_state' => 'CA',
          'facility_city' => 'OAKLAND',
          'facility_status' => 'LICENSED',
          'facility_telephone_number' => '(510) 893-9230',
          'facility_type' => 'FOSTER FAMILY AGENCY',
          'facility_zip' => '94612',
        }, {
          'facility_address' => '9998 CROW CANYON ROAD',
          'facility_name' => 'HOSANNA PATHWAYS',
          'facility_number' => '10707645',
          'facility_state' => 'CA',
          'facility_city' => 'CASTRO VALLEY',
          'facility_status' => 'LICENSED',
          'facility_telephone_number' => '(510) 538-8117',
          'facility_type' => 'FOSTER FAMILY AGENCY SUB',
          'facility_zip' => '94612',
        }, {
          'facility_address' => '522 GRAND AVE.',
          'facility_name' => 'AMERICAN INDIAN CHILD RESOURCE CENTER FFA',
          'facility_number' => '10707646',
          'facility_state' => 'CA',
          'facility_city' => 'OAKLAND',
          'facility_status' => 'LICENSED',
          'facility_telephone_number' => '(510) 208-1870',
          'facility_type' => 'FOSTER FAMILY AGENCY',
          'facility_zip' => '94612',
        }
      ].map do |hash|
        Hashie::Mash.new(hash)
      end

      expect_any_instance_of(SODA::Client).to receive(:get).and_return(response)

      login_as user
      visit foster_family_agencies_path

      expect(page).to have_content("Foster Family Agencies in #{zip_code}")

      expect(page).to have_content('FAMILYPATHS, INC')
      expect(page).to have_content('1727 Martin Luther King Wy#109, Oakland, CA 94612')
      expect(page).to have_content('(510) 893-9230')

      expect(page).to have_content('HOSANNA PATHWAYS')
      expect(page).to have_content('9998 Crow Canyon Road, Castro Valley, CA 94612')
      expect(page).to have_content('(510) 538-8117')

      expect(page).to have_content('AMERICAN INDIAN CHILD RESOURCE CENTER FFA')
      expect(page).to have_content('522 Grand Ave., Oakland, CA 94612')
      expect(page).to have_content('(510) 208-1870')
    end

    scenario "displays no rows when no foster family agencies in the user's zip code" do
      response = {}

      expect_any_instance_of(SODA::Client).to receive(:get).and_return(response)

      login_as user
      visit foster_family_agencies_path

      expect(page).to have_content("Foster Family Agencies in #{zip_code}")
      expect(page.all('table tbody tr').count).to eq 0
    end
  end

  context 'show page' do
    before do
      response = [
        Hashie::Mash.new({
          'facility_address' => '1727 MARTIN LUTHER KING WY#109',
          'facility_administrator' => 'MARCELLA REEVES',
          'facility_capacity' => '10',
          'facility_name' => 'FAMILYPATHS, INC.',
          'facility_number' => '10707644',
          'facility_state' => 'CA',
          'facility_city' => 'OAKLAND',
          'facility_status' => 'LICENSED',
          'facility_telephone_number' => '(510) 893-9230',
          'facility_type' => 'FOSTER FAMILY AGENCY',
          'facility_zip' => '94612',
        })
      ]
      allow_any_instance_of(SODA::Client).to receive(:get).and_return(response)
    end

    scenario 'display foster family agency information' do
      login_as user
      visit foster_family_agencies_path

      expect(page).to have_content('FAMILYPATHS, INC')

      click_link 'FAMILYPATHS, INC'

      expect(page).to have_content('FAMILYPATHS, INC')
      expect(page).to have_content('1727 Martin Luther King Wy#109, Oakland, CA 94612')
      expect(page).to have_content('(510) 893-9230')
      expect(page).to have_content('Capacity: 10')
      expect(page).to have_content('Administrator: Marcella Reeves')
    end

    scenario 'display associated case workers' do
      case_worker_1 = FactoryGirl.create(:case_worker, foster_family_agency_number: 10707644)
      case_worker_2 = FactoryGirl.create(:case_worker, foster_family_agency_number: 10707644)
      non_case_worker = FactoryGirl.create(:user_with_addresses)
      case_worker_for_another_ffa = FactoryGirl.create(:case_worker, foster_family_agency_number: 23333333)

      login_as user
      visit foster_family_agencies_path

      click_link 'FAMILYPATHS, INC'

      expect(page).to have_content(case_worker_1.first_name)
      expect(page).to have_content(case_worker_1.last_name)
      expect(page).to have_content(case_worker_2.first_name)
      expect(page).to have_content(case_worker_2.last_name)

      expect(page).to_not have_content(case_worker_for_another_ffa.first_name)
      expect(page).to_not have_content(case_worker_for_another_ffa.last_name)
      expect(page).to_not have_content(non_case_worker.first_name)
      expect(page).to_not have_content(non_case_worker.last_name)
    end
  end
end
