require 'rails_helper'

RSpec.describe ResourcesController, type: :controller do
  let(:current_user) { FactoryGirl.create(:user_with_addresses) }
  let(:client) { double(:client) }

  before do
    sign_in current_user
    allow(controller).to receive(:current_user).and_return(current_user)
    allow(controller).to receive(:client).and_return(client)
  end

  describe '#index' do
    let(:resources) { [double(:resource), double(:resource)]}
    it 'loads the resources from api endpoint' do
      expect(client).to receive(:get)
        .with(described_class::DATA_SET_URL, anything)
        .and_return(resources)

      get :index

      expect(assigns(:resources)).to eq resources
    end

    it 'loads the licensed resources' do
      expect(client).to receive(:get).with(
        anything,
        hash_including({
          '$where' => include("facility_status = 'LICENSED'")
        })
      ).and_return(resources)

      get :index

      expect(assigns(:resources)).to eq resources
    end

    it 'loads the resources for the user zip code' do
      expect(client).to receive(:get).with(
        anything,
        hash_including({
          '$where' => include("facility_zip = '#{current_user.primary_address.zip_code}'")
        })
      ).and_return(resources)

      get :index

      expect(assigns(:resources)).to eq resources
    end

    it 'loads the foster family resources' do
      expect(client).to receive(:get).with(
        anything,
        hash_including({
          '$where' => include("(facility_type = 'FOSTER FAMILY AGENCY' OR facility_type = 'FOSTER FAMILY AGENCY SUB')")
        })
      ).and_return(resources)

      get :index

      expect(assigns(:resources)).to eq resources
    end
  end

  describe '#show' do
    it 'loads the resource' do
      resource = double(:resource)
      expect(client).to receive(:get).with(
        described_class::DATA_SET_URL,
        { 'facility_number' => '10010010' }
      ).and_return([resource])

      get :show, id: '10010010'

      expect(assigns(:resource)).to eq resource
    end
  end
end
