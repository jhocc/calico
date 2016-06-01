require 'rails_helper'

RSpec.describe MessagesController, type: :controller do
  describe '#index' do
    let(:current_user) { FactoryGirl.create(:user) }

    before do
      sign_in current_user
      allow(controller).to receive(:current_user).and_return(current_user)
    end

    it 'returns the users list of channels' do
      phillip_fry = FactoryGirl.build(:user, first_name: 'Phillip', last_name: 'Fry')
      turanga_leela = FactoryGirl.build(:user, first_name: 'Turanga', last_name: 'Leela')
      channel_one = FactoryGirl.create(:channel, users: [phillip_fry, current_user])
      channel_two = FactoryGirl.create(:channel, users: [turanga_leela, current_user])

      get :index, format: :json
      json = JSON.parse(response.body)
      expect(json[0]['id']).to eq(channel_one.id)
      expect(json[0]['channels_users'][0]['user_id']).to eq(phillip_fry.id)
      expect(json[0]['channels_users'][0]['user']['first_name']).to eq('Phillip')
      expect(json[0]['channels_users'][0]['user']['last_name']).to eq('Fry')
      expect(json[1]['id']).to eq(channel_two.id)
      expect(json[1]['channels_users'][0]['user_id']).to eq(turanga_leela.id)
      expect(json[1]['channels_users'][0]['user']['first_name']).to eq('Turanga')
      expect(json[1]['channels_users'][0]['user']['last_name']).to eq('Leela')
    end
  end
end
