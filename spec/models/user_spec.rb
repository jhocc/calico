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

  it 'requires first_name' do
    user = FactoryGirl.build(:user, first_name: nil)
    expect(user).to be_invalid
    expect(user.errors[:first_name]).to be_present
  end

  it 'requires last_name' do
    user = FactoryGirl.build(:user, last_name: nil)
    expect(user).to be_invalid
    expect(user.errors[:last_name]).to be_present
  end
end
