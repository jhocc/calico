require 'gulp_assets'
class ApplicationController < ActionController::Base
  force_ssl if: :ssl_configured?

  include GulpAssets::Helper
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  skip_before_action :verify_authenticity_token, if: :json_request?

  helper_method :gulp_asset_path

  def ssl_configured?
    Rails.env.production?
  end

  protected

  def json_request?
    request.format.json?
  end
end
