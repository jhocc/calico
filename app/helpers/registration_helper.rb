module RegistrationHelper
  def minimum_password_message
    if @minimum_password_length
      "#{@minimum_password_length} characters minimum"
    end
  end
end
