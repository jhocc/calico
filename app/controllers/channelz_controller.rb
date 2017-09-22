class ChannelzController < ApplicationController
  before_action :authenticate_user!
  before_action :use_breezy

  def create
  end

  def index
  end

  def mark
  end

  private

  def channel_params
    params.permit(:user_id, :channel_id)
  end
end
