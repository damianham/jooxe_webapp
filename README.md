Jooxe
=====

This is an example application that uses Jooxe, the zero code web application framework.  


Visit http://www.jooxe.org for all the latest news and gossip.  However since Jooxe
is all very experimental don't expect to actually see anything there right now :)

## Installation

git clone git@github.com:damianham/jooxe.git
git clone git@github.com:damianham/jooxe_webapp.git
cd jooxe_webapp
bundle install

edit config/application.rb and setup the Sequel database connection parameters

# Build the database schema

rake build_schema[your_database_name,your_database_user,database_user_password]

replacing your_database_name with th ename of the database to generate the schema for and 
your_database_user,database_user_password with values that
have privileges to read the information_schema database.

# Running the example application

rackup config.ru

Then open a browser and visit http://localhost:9292

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
