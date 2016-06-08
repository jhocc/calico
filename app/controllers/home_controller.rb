class HomeController < ApplicationController
  def index
    if current_user.blank?
      redirect_to new_user_session_path
    end
    @open_channel_id = params[:open_channel_id] || 0
  end
end
