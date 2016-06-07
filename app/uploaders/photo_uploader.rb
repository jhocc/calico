# encoding: utf-8

class PhotoUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  include CarrierWave::Compatibility::Paperclip

  def store_dir
    "assets/images/#{mounted_as}/#{model.id}/"
  end

  AVATAR_COLORS = {
    'public' => '8ba6ca',
    'case_worker' => '95bfa2'
  }.freeze

  SIZE = {
    small: 75,
    large: 350
  }

  delegate :url_helpers, to: 'Rails.application.routes'

  version :small do
    process :resize_to_fill => [SIZE[:small], SIZE[:small]]
  end

  version :large do
    process :resize_to_fill => [SIZE[:large], SIZE[:large]]
  end

  def store_dir
    "assets/images/#{mounted_as}/#{model.id}/"
  end

  def default_url
    url_helpers.send(:avatar_path, avatar_size, AVATAR_COLORS[model.role], model.name)
  end

  def avatar_size
    SIZE[version_name] || 350
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end
end
