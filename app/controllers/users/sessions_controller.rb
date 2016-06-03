class Users::SessionsController < Devise::SessionsController
  before_action :set_cover_image, only: :new

  def set_cover_image
    @html_class = 'cover'
  end
end
