class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]
  before_action :configure_account_update_params, only: [:update]
  after_action :generate_signup_message, only: [:create]

  def edit
    set_minimum_password_length
    super
  end

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

  def generate_signup_message
    calico_feedback_user = User.find_or_initialize_by(email: 'calico_feedback_user@casecommons.org') do |user|
      user.first_name = 'Calico Feedback'
      user.last_name = 'User'
      user.password = SecureRandom.uuid
    end

    welcome_message = <<-MSG
      Hi there!
      Welcome to Calico, a messaging app for caseworkers, birth and foster parents, designed to help coordinate and communicate.
      To get started, click on the menu button (embed icon?) and go to the resource finder.
      This will put you in touch with foster family agencies in your area.
      From there, select a resource and you will see a list of caseworkers that you can message.
      Next time you login, you will see all conversations with caseworkers on your home page so you can message there.
    MSG

    feedback_channel = current_user.channels.build(users: [calico_feedback_user, current_user])
    feedback_channel.messages.build(content: welcome_message, user: calico_feedback_user)
    feedback_channel.save!
  end
end
