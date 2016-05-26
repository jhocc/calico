require 'rails_helper'
describe Address do
  describe 'validations' do
    it 'validates presence of zip code' do
      address = FactoryGirl.build(:address, zip_code: nil)
      expect(address.valid?).to be_falsey
    end
  end
end
