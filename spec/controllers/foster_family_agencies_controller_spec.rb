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
    let(:foster_family_agencies) { [double(:foster_family_agency), double(:foster_family_agency) ]}
    it 'loads the foster_family_agencies from api endpoint' do
      expect(service).to receive(:find_by_zip_code)
        .with(current_user.primary_address.zip_code)
        .and_return(foster_family_agencies)

      get :index

      expect(assigns(:foster_family_agencies)).to eq foster_family_agencies
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
