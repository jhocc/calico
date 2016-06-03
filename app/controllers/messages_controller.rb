class MessagesController < ApplicationController
  before_action :authenticate_user!

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
end
