class ChannelsController < ApplicationController
  before_action :authenticate_user!

  def create
    chat_user = User.find(channel_params[:user_id])
    Channel.create(users: [current_user, chat_user])

    redirect_to root_path
  end

  def index
    @channels = current_user.channels.includes({messages: :user, channels_users: :user}).order(
      Channel.arel_table[:created_at].asc,
    )

    respond_to do |format|
      format.json {
        render json: @channels.to_json(include: {
          messages: { include: :user },
          channels_users: { include: :user }
        })
      }
    end
  end

  def mark
    channel_id = channel_params[:channel_id]
    @channel_user = ChannelsUser.find_by(user_id: current_user.id, channel_id: channel_id)
    @channel_user.update!(read_at: Time.current)
    respond_to do |format|
      format.json { render json: {} }
    end
  end

  private

  def channel_params
    params.permit(:user_id, :channel_id)
  end
end
