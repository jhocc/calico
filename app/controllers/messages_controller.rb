class MessagesController < ApplicationController
  before_action :authenticate_user!

  def index
    @channels = current_user.channels.includes(channels_users: :user)

    respond_to do |format|
      format.html
      format.json { render json: @channels.to_json(include: { channels_users: { include: :user } }) }
    end
  end
end
