require 'rails_helper'

RSpec.describe Users::RegistrationsController, type: :controller do
  let(:current_user) { FactoryGirl.create(:user_with_addresses) }

  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    sign_in current_user
    allow(controller).to receive(:current_user).and_return(current_user)
  end

  describe '#update' do
    render_views

    it 'does not require password when update first/last name and addresses' do
      put :update, {
        user: {
          first_name: 'John',
          last_name: 'Doe',
          phone: '234-123-123',
          email: 'test@example.com'
        }
      }

      current_user.reload

      expect(current_user.first_name).to eq 'John'
      expect(current_user.last_name).to eq 'Doe'
      expect(current_user.phone).to eq '234-123-123'
      expect(current_user.email).to eq 'test@example.com'
    end

    it 'does require password, current_password and password confirmation when updating the password' do
      put :update, {
        user: {
          first_name: 'John',
          last_name: 'Doe',
          phone: '234-123-123',
          email: 'test@example.com',
          password: 'password'
        }
      }

      expect(response.status).to eq 200
      expect(response.body).to include "1 error prohibited this user from being saved"
    end
  end

  describe '#edit' do
    it 'set minimum password length' do
      expect(controller).to receive(:set_minimum_password_length)
      get :edit
    end
  end
end