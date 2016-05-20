require 'capybara/rspec'
require 'capybara/accessible'

Capybara.default_driver = :accessible
Capybara.javascript_driver = Capybara.default_driver

Capybara.default_wait_time = (ENV['CI'] || ENV['SOLANO']) ? 30 : 10

Capybara.server_port = 3101

RSpec.configure do |config|
  config.before(:each, js: true) do
    begin
      Capybara.page.driver.browser.manage.window.resize_to(1280,1024)
    rescue ChildProcess::TimeoutError, Selenium::WebDriver::Error::WebDriverError => e
      if ENV['SOLANO']
        puts '*** MEMORY ***'
        puts `free -m`
        puts '*** RESOURCE USAGE ***'
        puts `ps -eo pmem,pcpu,vsize,pid,cmd | sort -k 1 -nr | head -5`
        puts '*** FIREFOX ***'
        puts `ps auxwwwf | grep -i -C 7 [f]irefox`
        puts '*** WORKER IDENTITY ***'
        puts `uname -a`
        puts `hostname`
        fail e.message
      else
        raise e
      end
    end
  end
end

# Logging
Capybara.server do |app, port|
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
