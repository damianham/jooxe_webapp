source 'http://rubygems.org'

gem 'rack'
gem 'rack-contrib'
gem 'sequel'
gem 'tilt'
gem 'json_pure'

# Deploy with Capistrano
gem 'capistrano'

platform :ruby_19 do
  gem 'mysql2'
  #gem 'sqlite3'
end

platform :jruby do
  gem 'jdbc-mysql'
  #gem 'jdbc-sqlite3'
end

group :development, :test do
  gem 'ruby-debug-ide'
  gem 'rspec'
  gem 'capybara'
  gem 'watchr'
  gem 'spork'
end
