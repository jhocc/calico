require 'json'
require 'uri'

module GulpAssets
  module Helper
    MANIFEST_PATH = Rails.root.join('public', 'assets', 'rev-manifest.json').freeze

    def gulp_asset_path(name)
      is_dev_env = Rails.env == 'development'
      is_test_env = Rails.env  == 'test'

      use_manifest = !(is_dev_env || is_test_env)
      use_gulp_server = is_dev_env

      if use_manifest
        name = manifest[name]
      end

      if use_gulp_server
        uri = URI::HTTP.build(host: request.host, port: 4857)
      else
        uri = URI::Generic.build({})
      end

      uri.path = "/assets/#{name}"
      uri.to_s
    end

    def manifest
      raise 'Cannot find asset manifest!' unless File.exist?(MANIFEST_PATH)
      @manifest ||= JSON.parse(File.read(MANIFEST_PATH))
    end
  end
end
