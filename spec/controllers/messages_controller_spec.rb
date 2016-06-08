require 'rails_helper'

RSpec.describe MessagesController, type: :controller do
  let(:current_user) { FactoryGirl.create(:user, first_name: 'Current', last_name: 'User') }

  describe '#create' do
    let(:phillip_fry) do
      FactoryGirl.build(
        :user,
        first_name: 'Phillip',
        last_name: 'Fry',
        email: 'phillip.fry@futuramalabs.com'
      )
    end
    let!(:channel) { FactoryGirl.create(:channel, users: [phillip_fry, current_user]) }

    before do
      sign_in current_user
    end

    it 'creates a message with the current user in the selected channel' do
      expect {
        post :create, { channel_id: channel.id, message: { content: 'hello' }, format: :json }
      }.to change(Message, :count).by(1)
      expect(current_user.channels.first.messages.first.content).to eq 'hello'
      expect(current_user.channels.first.messages.first.user_id).to eq current_user.id
      expect(current_user.channels.first.messages.first.channel_id).to eq channel.id
    end

    it 'updates the channels updated at' do
      expect {
        post :create, { channel_id: channel.id, message: { content: 'hello' }, format: :json }
      }.to change {
        channel.reload.updated_at
      }
    end
  end
end


