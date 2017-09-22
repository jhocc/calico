class ChannelzController < ApplicationController
  before_action :authenticate_user!
  before_action :use_breezy

  def create
  end

  def index
  end

  def mark
  end

  def show
  end

  def message
    binding.pry
    @channel = Channel.find(message_params[:channelz_id])
    content = message_params[:message][:content]
    message = @channel.messages.build(user: current_user, content: content)

    message.save!
    message.channel.touch(:updated_at)

    redirect_to :back
  end

  private

  def message_params
    params.permit(:channelz_id, message: [:content])
  end

  def channel_params
    params.permit(:user_id, :channel_id)
  end
end
