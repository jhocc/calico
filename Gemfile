source 'https://rubygems.org'

gem 'rails', '4.2.6'
gem 'pg'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 2.0'

# bundle exec rake doc:rails generates the API under doc/api.
# gem 'sdoc', '~> 0.4.0', group: :doc

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
# gem 'unicorn'

group :development, :test do
  gem 'factory_girl_rails', require: false

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

  gem 'capybara', require: false
  gem 'capybara-accessible', require: false, git: 'git@github.com:Casecommons/capybara-accessible.git', ref: '9681e59f326ca9b227e16f45a22d29063f6a6b90'
  gem 'capybara-firebug', require: false
  gem 'capybara-screenshot', require: false
end
