require 'json'
require 'uri'

module GulpAssets
  module Helper
    MANIFEST_PATH = Rails.root.join('public', 'assets', 'rev-manifest.json').freeze

    def gulp_asset_path(name)
      if Rails.env == 'development'
        uri = URI::HTTP.build(host: request.host, port: 4857)
      else
        uri = URI::Generic.build({})
      end

      if use_manifest?
        uri.path = "/assets/#{manifest[name]}"
      else
        uri.path = "/assets/#{name}"
      end

      uri.to_s
    end

    def use_manifest?
      Rails.env != 'development' && Rails.env != 'test'
    end

    def manifest
      raise 'Cannot find asset manifest!' unless File.exist?(MANIFEST_PATH)
      @manifest ||= JSON.parse(File.read(MANIFEST_PATH))
    end
  end
end
