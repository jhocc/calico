CarrierWave.configure do |config|
  if Rails.env == 'test' || (Rails.env == 'development' && ENV['USE_S3'] != 'y')
    config.storage = :file
  else
    config.fog_credentials = {
      provider:              'AWS',
      aws_access_key_id:      ENV['AWS_ACCESS_KEY_ID'],
      aws_secret_access_key:  ENV['AWS_SECRET_ACCESS_KEY'],
      region:                 ENV['AWS_REGION'],
    }
    config.fog_directory  = ENV['AWS_BUCKET']
    config.fog_public = false
    config.fog_attributes = {'x-amz-server-side-encryption' => 'AES256'}

    config.storage = :fog
  end
end
