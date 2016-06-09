class MessagesController < ApplicationController
  before_action :authenticate_user!

  def create
    @channel = Channel.find(message_params[:channel_id])
    content = message_params[:message][:content]
    message = @channel.messages.build(user: current_user, content: content)
    message.save!
    message.channel.touch(:updated_at)

    respond_to do |format|
      format.json { render json: {} }
    end
  end

  private

  def message_params
    params.permit(:channel_id, message: [:content])
  end
end
