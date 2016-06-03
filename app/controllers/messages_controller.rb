class MessagesController < ApplicationController
  before_action :authenticate_user!

  def create
    chat_user = User.find(channel_params[:user_id])
    Channel.create(users: [current_user, chat_user])

    redirect_to messages_path
  end

  def index
    @channels = current_user.channels.includes({messages: :user, channels_users: :user}).order(
      Channel.arel_table[:created_at].asc,
    )

    respond_to do |format|
      format.html
      format.json {
        render json: @channels.to_json(include: {
          messages: { include: :user },
          channels_users: { include: :user }
        })
      }
    end
  end

  private

  def channel_params
    params.permit(:user_id)
  end
end
