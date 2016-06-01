class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]
  before_action :configure_account_update_params, only: [:update]

  protected
  def update_resource(resource, update_account_params)
    if updating_password?(update_account_params)
      resource.update_with_password(update_account_params)
    else
      resource.update_attributes(update_account_params)
    end
  end

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_up_params
    devise_parameter_sanitizer.permit(
      :sign_up,
      keys: [
        :first_name,
        :last_name,
        :phone,
        :email,
        :addresses_attributes => [
          :street_address, :city, :state, :zip_code
        ]
      ]
    )
  end

  # If you have extra params to permit, append them to the sanitizer.
  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [
      :first_name,
      :last_name,
      :phone,
      :email,
      :addresses_attributes => [
        :street_address, :city, :state, :zip_code, :id
      ]
    ])

    # devise allow current_password, password params as default
    if !updating_password?(params[:user])
      except_keys = [
        :current_password,
        :password,
        :password_confirmation,
      ]
      devise_parameter_sanitizer.permit(:account_update, except: except_keys)
    end
  end

  def updating_password?(update_account_params)
    update_account_params[:current_password].present? ||
      update_account_params[:password].present?
  end
end
