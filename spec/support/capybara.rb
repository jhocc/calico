require 'capybara/rspec'
require 'capybara/accessible'

Capybara.default_driver = :accessible
Capybara.javascript_driver = Capybara.default_driver
Capybara.server_port = 3101

# Logging
Capybara.register_server :webrick do |app, port, host|
  require 'rack/handler/webrick'
  Rack::Handler::WEBrick.run(app, :Port => port, :AccessLog => [], :Logger => WEBrick::Log::new(Rails.root.join('log/capybara_server.log').to_s))
end

# Chrome support
Capybara.register_driver :selenium_chrome do |app|
  Capybara::Selenium::Driver.new(app, :browser => :chrome)
end

# Accessible
Capybara.register_driver :accessible do |app|
  http_client = Selenium::WebDriver::Remote::Http::Default.new
  http_client.timeout = 120
  profile = Selenium::WebDriver::Firefox::Profile.new
  profile['browser.download.dir'] = Rails.root.join("tmp").to_s
  profile['browser.download.folderList'] = 2 # 0 for Desktop, 1 for Downloads, 2 for Custom
  profile['browser.helperApps.neverAsk.saveToDisk'] = "image/jpeg"
  Capybara::Accessible::Driver.new(app, profile: profile)
end

Capybara::Accessible::Auditor.exclusions = %w{ AX_FOCUS_01 AX_FOCUS_02 AX_COLOR_01 }
Capybara::Accessible::Auditor.severe_rules = %w{ AX_TEXT_02 }

RSpec.configure do |config|
  config.around(:each, inaccessible: true) do |example|
    Capybara::Accessible.skip_audit { example.run }
  end
end
