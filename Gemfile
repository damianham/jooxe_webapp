source 'http://rubygems.org'

gem 'jooxe', :path => '../jooxe'

gem 'rack'
gem 'rack-contrib'

# Deploy with Capistrano
gem 'capistrano'

platform :ruby_19 do
  gem 'mysql2'
  #gem 'sqlite3'
  group :development, :test do
    gem "better_errors"
    gem "binding_of_caller"
  end
end

platform :jruby do
  gem 'jdbc-mysql'

  group :development, :test do
    gem 'jdbc-sqlite3'
    gem 'ruby-debug-ide'
  end
end

group :development, :test do
  
  gem 'rspec'
  gem 'capybara'
  gem 'cucumber'
  gem 'watchr'
  gem 'spork'
  gem 'yard'
end
