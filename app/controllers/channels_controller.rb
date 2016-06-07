class ChannelsController < ApplicationController
  before_action :authenticate_user!

  def create
    user_id = channel_params[:user_id]
    user_table = ChannelsUser.arel_table
    current_user_channels = Channel.joins(:channels_users).where(user_table[:user_id].eq(user_id))
    other_user_channels = Channel.joins(:channels_users).where(user_table[:user_id].eq(current_user.id))
    existing_channel = other_user_channels.where(id: current_user_channels.pluck(:id).uniq).first

    if existing_channel.nil?
      chat_user = User.find(user_id)
      Channel.create(users: [current_user, chat_user])
    else
      existing_channel.touch(:updated_at)
    end

    redirect_to root_path
  end

  def index
    @channels = current_user.channels.includes({messages: :user, channels_users: :user}).order(
      Channel.arel_table[:updated_at].desc,
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
