source 'https://rubygems.org'

gem 'rails', '4.2.6'
gem 'pg'
gem 'foreman', require: false

gem 'devise', '4.1.1'
gem 'puma'
gem 'soda-ruby', :require => 'soda'

gem 'faker'
gem 'carrierwave'
gem 'fog'
gem 'mini_magick', git: 'https://github.com/fschwahn/mini_magick.git'
gem 'dragonfly'
gem 'avatar_magick'


group :production do
  gem 'newrelic_rpm'
  gem 'rails_12factor'
end

group :development, :test do
  gem 'factory_girl_rails', require: false
  gem 'dotenv-rails'

  gem 'pry'
  gem 'pry-byebug'
  gem 'pry-doc'
  gem 'pry-rails'
  gem 'pry-remote'
  gem 'pry-stack_explorer'
  gem 'pry-theme'
end
group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
end

group :test do
  gem 'rspec-rails', '~> 3.4'
  gem 'solano', require: false
  gem 'database_cleaner'
  gem 'capybara', require: false
  gem 'selenium-webdriver'
  gem 'capybara-firebug', require: false
  gem 'capybara-screenshot', require: false
end
