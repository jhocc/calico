class HomeController < ApplicationController
  def index
    if current_user.blank?
      redirect_to new_user_session_path
    else
      most_recent_channel_id = current_user.channels.order(Channel.arel_table[:updated_at].desc).pluck(:id).first()
      @open_channel_id = params[:open_channel_id] || most_recent_channel_id
    end
  end
end
