require 'rails_helper'

RSpec.describe ChannelsController, type: :controller do
  let(:current_user) { FactoryGirl.create(:user, first_name: 'Current', last_name: 'User') }

  describe '#create' do
    let(:other_user) { FactoryGirl.create(:user) }
    before do
      sign_in current_user
    end

    describe 'when there is no existing channel between current user and the user passed' do
      it 'creates a channel with the current user and the user passed' do
        expect {
          post :create, { user_id: other_user }
        }.to change(Channel, :count).by(1)
      end
    end

    describe 'when there is as existing channel between current user and the user passed' do
      before { FactoryGirl.create(:channel, users: [current_user, other_user]) }
      it 'does not create a channel' do
        expect {
          post :create, { user_id: other_user }
        }.to change(Channel, :count).by(0)
      end
    end
  end

  describe '#index' do
    before do
      sign_in current_user
      allow(controller).to receive(:current_user).and_return(current_user)
    end

    it 'returns the users list of channels sorted by updated at' do
      phillip_fry = FactoryGirl.build(
        :user,
        first_name: 'Phillip',
        last_name: 'Fry',
        email: 'phillip.fry@futuramalabs.com'
      )
      turanga_leela = FactoryGirl.build(
        :user,
        first_name: 'Turanga',
        last_name: 'Leela',
        email: 'turanga.leela@futuramalabs.com'
      )
      bender_rodriguez = FactoryGirl.build(
        :user,
        first_name: 'Bender',
        last_name: 'Rodriguez',
        email: 'bender.rodriguez@futuramalabs.com'
      )
      channel_one = FactoryGirl.create(:channel, users: [phillip_fry, current_user])
      channel_one.messages << FactoryGirl.build(:message, user: phillip_fry, content: 'Hi there!')
      channel_two = FactoryGirl.create(:channel, users: [turanga_leela, current_user])
      channel_three = FactoryGirl.create(:channel, users: [current_user, bender_rodriguez])

      get :index, format: :json
      json = JSON.parse(response.body)

      channel_one_json = json.detect { |hash| hash['id'] == channel_one.id }
      expect(channel_one_json['id']).to eq(channel_one.id)
      expect(channel_one_json['messages'][0]['content']).to eq('Hi there!')
      expect(channel_one_json['messages'][0]['user']['first_name']).to eq('Phillip')
      expect(channel_one_json['messages'][0]['user']['last_name']).to eq('Fry')
      channel_user = channel_one_json['channels_users'].find { |user| user['user_id'] == phillip_fry.id }['user']
      expect(channel_user['id']).to eq(phillip_fry.id)
      expect(channel_user['first_name']).to eq('Phillip')
      expect(channel_user['last_name']).to eq('Fry')
      expect(channel_user['email']).to eq('phillip.fry@futuramalabs.com')

      channel_two_json = json.detect { |hash| hash['id'] == channel_two.id }
      channel_user = channel_two_json['channels_users'].find { |user| user['user_id'] == turanga_leela.id }['user']
      expect(channel_user['id']).to eq(turanga_leela.id)
      expect(channel_user['first_name']).to eq('Turanga')
      expect(channel_user['last_name']).to eq('Leela')
      expect(channel_user['email']).to eq('turanga.leela@futuramalabs.com')

      channel_ids = json.map do |channel_json|
        channel_json['id']
      end
      expect(channel_ids).to eq [channel_three.id, channel_two.id, channel_one.id]
    end
  end

  describe '#mark' do
    before do
      sign_in current_user
      allow(controller).to receive(:current_user).and_return(current_user)
    end

    it 'returns the users list of channels' do
      my_channel_user = FactoryGirl.build(:channels_user, user: current_user, read_at: 1.day.ago)
      channel = FactoryGirl.create(:channel, channels_users: [my_channel_user])
      previous_read = my_channel_user.read_at
      put :mark, { channel_id: channel.id, format: :json }
      expect(my_channel_user.reload.read_at).to be > (previous_read)
    end
  end
end
