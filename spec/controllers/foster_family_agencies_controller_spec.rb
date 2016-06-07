require 'rails_helper'

RSpec.describe FosterFamilyAgenciesController, type: :controller do
  let(:current_user) { FactoryGirl.create(:user_with_addresses) }
  let(:client) { double(:client) }
  let(:service) { double(:service) }

  before do
    sign_in current_user
    allow(controller).to receive(:current_user).and_return(current_user)
    allow(controller).to receive(:service).and_return(service)
  end

  describe '#index' do
    context 'when there are foster families in your zipcode' do
      let(:foster_family_agencies) { [double(:foster_family_agency), double(:foster_family_agency) ]}
      it 'loads the foster_family_agencies from api endpoint' do
        expect(service).to receive(:find_by_zip_code)
          .with(current_user.primary_address.zip_code)
          .and_return(foster_family_agencies)

        get :index
        expect(assigns(:foster_family_agencies)).to eq foster_family_agencies
      end
    end

    context 'when there are no foster families in your zipcode' do
      let(:foster_family_agencies) { [double(:foster_family_agency), double(:foster_family_agency) ]}
      it 'sets a flash message' do
        expect(service).to receive(:find_by_zip_code)
          .with(current_user.primary_address.zip_code)
          .and_return([])

        get :index
        expect(assigns(:foster_family_agencies)).to eq []
        expect(flash[:notice]).to eq 'There are no foster family agencies in your zip code'
      end
    end

    context 'when filtering by user entered zip code' do
      let(:foster_family_agencies) { [double(:foster_family_agency), double(:foster_family_agency) ]}
      it 'loads the foster_family_agencies from api endpoint' do
        new_zip_code = '11111'
        expect(service).to receive(:find_by_zip_code)
          .with(new_zip_code)
          .and_return(foster_family_agencies)

        get :index, {zip_code: new_zip_code}
        expect(assigns(:foster_family_agencies)).to eq foster_family_agencies
        expect(assigns(:current_zip_code)).to eq new_zip_code
      end
    end
  end

  describe '#show' do
    it 'loads the foster family agency and associated case workers' do
      foster_family_agency = double(:foster_family_agency)
      case_worker = double(:case_worker)
      expect(User).to receive_message_chain(:case_workers, :where)
        .with(foster_family_agency_number: '10010010')
        .and_return([case_worker])

      expect(service).to receive(:find)
        .with('10010010')
        .and_return(foster_family_agency)

      get :show, id: '10010010'

      expect(assigns(:foster_family_agency)).to eq foster_family_agency
      expect(assigns(:associated_case_workers)).to eq [case_worker]
    end
  end
end
