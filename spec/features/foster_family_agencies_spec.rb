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

      expect(page).to have_content("Foster Family Agencies in")
      expect(page).to have_button('Update ZIP')
      expect(page).to have_field('zip_code', with: zip_code)

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

    scenario "displays no rows and flash message when no foster family agencies in the user's zip code" do
      response = {}

      expect_any_instance_of(SODA::Client).to receive(:get).and_return(response)

      login_as user
      visit foster_family_agencies_path

      expect(page).to have_content("Foster Family Agencies in")
      expect(page).to have_field('zip_code', with: zip_code)

      expect(page.all('table tbody tr').count).to eq 0
      expect(page).to have_content("There are no foster family agencies in your zip code")
    end

    scenario 'displays no flash message when changing from zip code without foster family agencies to zip code with agency' do
      response1 = {}

      response2 = [Hashie::Mash.new({
        'facility_address' => '40W 23rd Street',
        'facility_name' => 'Case Commons',
        'facility_number' => '10707649',
        'facility_state' => 'NY',
        'facility_city' => 'New York',
        'facility_status' => 'LICENSED',
        'facility_telephone_number' => '(234) 234-1234',
        'facility_type' => 'FOSTER FAMILY AGENCY',
        'facility_zip' => '10010',
      })]

      allow_any_instance_of(FosterFamilyAgencyService).to receive(:find_by_zip_code)
        .with(zip_code)
        .and_return(response1)

      allow_any_instance_of(FosterFamilyAgencyService).to receive(:find_by_zip_code)
        .with('10010')
        .and_return(response2)

      login_as user
      visit foster_family_agencies_path

      expect(page).to have_content("There are no foster family agencies in your zip code")

      fill_in 'zip_code', with: '10010'
      click_button 'Update ZIP'

      expect(page).to_not have_content("There are no foster family agencies in your zip code")
    end

    scenario 'change zip and display foster family agencies in new zip code' do
      response1 = [Hashie::Mash.new({
        'facility_address' => '1727 MARTIN LUTHER KING WY#109',
        'facility_name' => 'FAMILYPATHS, INC.',
        'facility_number' => '10707644',
        'facility_state' => 'CA',
        'facility_city' => 'OAKLAND',
        'facility_status' => 'LICENSED',
        'facility_telephone_number' => '(510) 893-9230',
        'facility_type' => 'FOSTER FAMILY AGENCY',
        'facility_zip' => '94612',
      })]

      response2 = [Hashie::Mash.new({
        'facility_address' => '40W 23rd Street',
        'facility_name' => 'Case Commons',
        'facility_number' => '10707649',
        'facility_state' => 'NY',
        'facility_city' => 'New York',
        'facility_status' => 'LICENSED',
        'facility_telephone_number' => '(234) 234-1234',
        'facility_type' => 'FOSTER FAMILY AGENCY',
        'facility_zip' => '10010',
      })]

      allow_any_instance_of(FosterFamilyAgencyService).to receive(:find_by_zip_code)
        .with(zip_code)
        .and_return(response1)

      allow_any_instance_of(FosterFamilyAgencyService).to receive(:find_by_zip_code)
        .with('10010')
        .and_return(response2)

      login_as user
      visit foster_family_agencies_path

      expect(page).to have_content("Foster Family Agencies in")
      expect(page).to have_field('zip_code', with: zip_code)

      expect(page).to have_content('FAMILYPATHS, INC')
      expect(page).to have_content('1727 Martin Luther King Wy#109, Oakland, CA 94612')
      expect(page).to have_content('(510) 893-9230')

      fill_in 'zip_code', with: '10010'

      click_button 'Update ZIP'

      expect(page).to have_content("Foster Family Agencies in")
      expect(page).to have_field('zip_code', with: 10010)

      expect(page).to have_content('Case Commons')
      expect(page).to have_content('40 W 23rd Street, New York, NY 10010')
      expect(page).to have_content('(234) 234-1234')
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

    scenario 'user messages an associated worker by clicking a link' do
      FactoryGirl.create(
        :case_worker,
        first_name: 'Robert',
        last_name: 'Smith',
        foster_family_agency_number: 10707644
      )

      login_as user
      visit foster_family_agencies_path

      click_link 'FAMILYPATHS, INC'
      click_link 'Message Robert'

      expect(page).to have_content('Conversation with Robert Smith')
      within '.channels' do
        expect(page).to have_content('Robert Smith')
      end
    end

    scenario 'user opens existing channel with associated worker by clicking a link' do
      other_case_worker = FactoryGirl.create(
        :case_worker,
        first_name: 'Sarah',
        last_name: 'Sheehan',
        foster_family_agency_number: 10707644
      )
      case_worker = FactoryGirl.create(
        :case_worker,
        first_name: 'Robert',
        last_name: 'Smith',
        foster_family_agency_number: 10707644
      )
      FactoryGirl.create(:channel, users: [case_worker, user])
      FactoryGirl.create(:channel, users: [other_case_worker, user])

      login_as user

      visit root_path
      within '.channels .active' do
        expect(page).to have_content('Sarah Sheehan')
      end

      visit foster_family_agencies_path

      click_link 'FAMILYPATHS, INC'
      click_link 'Message Robert'

      page.find_all('.channels li').count
      within '.channels' do
        expect(page.find_all('li').count).to eq 2
      end

      expect(page).to have_content('Conversation with Robert Smith')
      within '.channels .active' do
        expect(page).to have_content('Robert Smith')
      end
    end
  end
end
