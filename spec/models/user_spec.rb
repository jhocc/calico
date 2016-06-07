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

  describe 'profile_photo' do
    it 'mount PhotoUploader to profile_photo' do
      expect(described_class.new.profile_photo.class).to eq PhotoUploader
    end
  end

  describe '#is_feedback_user?' do
    it 'returns true if user email is feedback user email' do
      user = FactoryGirl.build(:user, email: User::FEEDBACK_USER_EMAIL)
      expect(user.is_feedback_user?).to eq true
    end

    it 'returns false if user email is not feedback user email' do
      user = FactoryGirl.build(:user, email: Faker::Internet.email)
      expect(user.is_feedback_user?).to eq false
    end
  end

  describe '#is_case_worker?' do
    it 'returns true if user role is case_worker' do
      user = FactoryGirl.build(:user, role: Role::CASE_WORKER)
      expect(user.is_case_worker?).to eq true
    end

    it 'returns false if user role is NOT case_worker' do
      user = FactoryGirl.build(:user, role: Role::PUBLIC)
      expect(user.is_case_worker?).to eq false
    end
  end
end
