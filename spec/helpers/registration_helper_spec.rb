require 'rails_helper'

RSpec.describe RegistrationHelper, type: :helper do
  describe('.minimum_password_message') do
    it 'returns number of characters minimum message' do
      assign(:minimum_password_length, 16)
      expect(helper.minimum_password_message).to eq('16 characters minimum')
    end

    it 'returns nothing if minimum password length is not set' do
      expect(helper.minimum_password_message).to be_blank
    end
  end
end
