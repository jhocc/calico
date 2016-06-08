class HomeController < ApplicationController
  def index
    if current_user.blank?
      redirect_to new_user_session_path
    end
  end
end
