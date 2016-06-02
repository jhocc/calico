require 'rails_helper'

describe User do
  describe '#primary_address' do
   it 'returns most recent address associated with the user' do
    user = FactoryGirl.build(:user)
    address_01 = FactoryGirl.build(:address)
    user.addresses << address_01
    user.save!
    address_02 = FactoryGirl.build(:address)
    user.addresses << address_02
    user.save!

    expect(user.addresses.count).to eq(2)
    expect(user.primary_address).to eq(address_02)
   end

   it 'handles users with no addresses' do
    user = FactoryGirl.build(:user)
    expect(user.addresses.count).to eq(0)
    expect(user.primary_address).to be_nil
   end
  end

  describe 'after_create' do
    it 'creates a new channel with the current user and another user' do
      user = FactoryGirl.build(:user)
      expect { user.save! }.to change(ChannelsUser, :count).by(2)
    end
  end
end
