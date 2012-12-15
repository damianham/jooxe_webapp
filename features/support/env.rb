
# Set up gems listed in the Gemfile.
ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../../../Gemfile', __FILE__)

require 'bundler/setup' if File.exists?(ENV['BUNDLE_GEMFILE'])

require 'capybara/cucumber'
require 'yaml'
require 'sequel'


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


$LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__) + "/../.."))
$LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__) + "/../..") + "/lib")

require 'jooxe'