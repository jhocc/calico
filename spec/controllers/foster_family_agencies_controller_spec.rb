require 'rails_helper'

RSpec.describe FosterFamilyAgenciesController, type: :controller do
  let(:current_user) { FactoryGirl.create(:user_with_addresses) }
  let(:client) { double(:client) }

  before do
    sign_in current_user
    allow(controller).to receive(:current_user).and_return(current_user)
    allow(controller).to receive(:client).and_return(client)
  end

  describe '#index' do
    let(:foster_family_agencies) { [double(:foster_family_agency), double(:foster_family_agency) ]}
    it 'loads the foster_family_agencies from api endpoint' do
      expect(client).to receive(:get)
        .with(described_class::DATA_SET_URL, anything)
        .and_return(foster_family_agencies)

      get :index

      expect(assigns(:foster_family_agencies)).to eq foster_family_agencies
    end

    it 'loads the licensed foster_family_agencies' do
      expect(client).to receive(:get).with(
        anything,
        hash_including({
          '$where' => include("facility_status = 'LICENSED'")
        })
      ).and_return(foster_family_agencies)

      get :index

      expect(assigns(:foster_family_agencies)).to eq foster_family_agencies
    end

    it 'loads the foster_family_agencies for the user zip code' do
      expect(client).to receive(:get).with(
        anything,
        hash_including({
          '$where' => include("facility_zip = '#{current_user.primary_address.zip_code}'")
        })
      ).and_return(foster_family_agencies)

      get :index

      expect(assigns(:foster_family_agencies)).to eq foster_family_agencies
    end

    it 'loads the foster family foster_family_agencies' do
      expect(client).to receive(:get).with(
        anything,
        hash_including({
          '$where' => include("(facility_type = 'FOSTER FAMILY AGENCY' OR facility_type = 'FOSTER FAMILY AGENCY SUB')")
        })
      ).and_return(foster_family_agencies)

      get :index

      expect(assigns(:foster_family_agencies)).to eq foster_family_agencies
    end
  end

  describe '#show' do
    it 'loads the foster_family_agency' do
      foster_family_agency = double(:foster_family_agency)
      expect(client).to receive(:get).with(
        described_class::DATA_SET_URL,
        { 'facility_number' => '10010010' }
      ).and_return([foster_family_agency])

      get :show, id: '10010010'

      expect(assigns(:foster_family_agency)).to eq foster_family_agency
    end
  end
end
