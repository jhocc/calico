require 'rails_helper'

RSpec.describe HomeController, type: :controller do
  let(:current_user) { FactoryGirl.create(:user, first_name: 'Current', last_name: 'User') }

  describe '#index' do
    context 'when current user is not blank' do
      before { sign_in current_user }

      context 'when open_channel_id has not been passed' do
        let!(:older_channel) { FactoryGirl.create(:channel, users: [current_user]) }
        let!(:updated_channel) { FactoryGirl.create(:channel, users: [current_user]) }
        let!(:new_channel) { FactoryGirl.create(:channel, users: [current_user]) }

        before do
          updated_channel.touch(:updated_at)
        end

        it 'assigns the most recent channel' do
          get :index
          expect(assigns(:open_channel_id)).to eq updated_channel.id
        end
      end

      context 'when open_channel_id has been passed' do
        it 'assigns the open channel which is passed' do
          get :index, { open_channel_id: 2 }
          expect(assigns(:open_channel_id)).to eq '2'
        end
      end
    end
  end
end
