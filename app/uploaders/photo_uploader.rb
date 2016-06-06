# encoding: utf-8

class PhotoUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  include CarrierWave::Compatibility::Paperclip

  # Choose what kind of storage to use for this uploader:
  storage :file
  # storage :fog

  def store_dir
    "assets/images/#{mounted_as}/#{model.id}/"
  end

  def default_url
    if model.is_case_worker?
      "/assets/images/worker.svg"
    else
      "/assets/images/user.svg"
    end
  end

  version :small do
    process :resize_to_fill => [75, 75]
  end

  version :large do
    process :resize_to_fill => [350, 350]
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
