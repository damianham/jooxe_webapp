require 'rubygems'
require 'yaml'
require 'sequel'
require 'capybara/rspec'

# connect to an in-memory database
DB = Sequel.connect('jdbc:sqlite::memory:')

# load the fixtures into the db
# 
# create an items table
DB.create_table :users do
  primary_key :id
  String :account_name
  String :title
  String :given_name
  String :surname
  String :country
  String :mail
  DateTime :updated_at
  String :updated_by
end

# create a dataset from the items table
users = DB[:users]

# load the fixture with yaml
db = YAML::load( File.open( 'test/db/fixtures/users.yml' ) )

# populate the table
db.values.each do |v| 
  users.insert(v)
end


require 'jooxe'


require File.expand_path("../../config/jooxe", __FILE__)
  
# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir.glob("spec/support/**/*.rb").each {|f| require f}

RSpec.configure do |config|
  # == Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
  config.mock_with :rspec

end
