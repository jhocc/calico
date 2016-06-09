require 'rails_helper'

RSpec.describe Users::RegistrationsController, type: :controller do
  let(:current_user) { FactoryGirl.create(:user_with_addresses) }

  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  describe '#create' do
    it 'generates signup message with the calico feedback user on success' do
      post :create, {
        user: {
          first_name: 'John',
          last_name: 'Snow',
          phone: '234-123-123',
          email: 'test@example.com',
          password: 'password',
          password_confirmation: 'password'
        }
      }
      expect(response.status).to eq 302
      created_user = User.find_by(first_name: 'John', last_name: 'Snow')
      expect(created_user.channels.count).to eq 1
      expect(created_user.channels.first.users.count).to eq 2
    end

    it 'does NOT generate signup message with the calico feedback user on failure' do
      expect {
        put :create, {
          user: {
            first_name: 'John',
            last_name: 'Doe',
            phone: '234-123-123',
          }
        }
      }.to_not change(ChannelsUser, :count)
    end
  end

  context 'with sign in user' do
    before do
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

      context 'when user is case worker' do
        let(:current_user) do
          FactoryGirl.create(:case_worker,
                             password: 'test123',
                             password_confirmation: 'test123')
        end
        it 'can not change password' do
          expect_any_instance_of(User).to_not receive(:update_with_password)

          put :update, {
            user: {
              first_name: 'John',
              last_name: 'Doe',
              phone: '234-123-123',
              email: 'test@example.com',
              current_password: 'test123',
              password: 'password',
              password_confirmation: 'password',
            }
          }

          expect(response.status).to eq 302
        end
      end
    end

    describe '#edit' do
      it 'set minimum password length' do
        expect(controller).to receive(:set_minimum_password_length)
        get :edit
      end
    end
  end
end
