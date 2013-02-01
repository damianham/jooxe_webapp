
require 'yaml'
require 'jdbc/mysql'
require "java"

=begin
desc "insert stuff example"

task :insert_stuff_example , :database, :username, :password do |t, args|

  stmtInsert = connInsert.create_statement

  # Prep the connection
  Java::com.mysql.jdbc.Driver
  userurl = "jdbc:mysql://localhost/information_schema"
  connSelect = java.sql.DriverManager.get_connection(userurl, args['username'], args['password'])
  # Do the insert
  rsI = stmtInsert.execute_update("INSERT INTO vegetables (name,type,size,price)
        VALUES
             (
             '#{vegetable["name"]}',
             '#{vegetable["type"]}',
             '#{vegetable["size"]}',
             '#{vegetable["price"]}'
             );")

end
=end

desc "Build the schema from the given database"

# to specify default values,
# we take advantage of args being a Rake::TaskArguments object
task :build_schema, :database, :username, :password, :format do |t, args|
  args.with_defaults( :username => "test", :password => "test",  :format => :yaml )
  puts "Args with defaults were: #{args}"

  rel_columns = "column_name,referenced_table_schema,referenced_table_name,referenced_column_name"
  column_fields = "column_name,ordinal_position,data_type,is_nullable,character_maximum_length,numeric_precision,column_comment"
  result = {'schema' => {}}

  # create the schema object then export to a yaml file

  # Prep the connection
  Java::com.mysql.jdbc.Driver
  userurl = "jdbc:mysql://localhost/information_schema"
  connSelect = java.sql.DriverManager.get_connection(userurl, args['username'], args['password'])
  stmtSelect = connSelect.create_statement
	colSelect = connSelect.create_statement

  rsS = stmtSelect.execute_query("SELECT TABLE_NAME,TABLE_COMMENT FROM TABLES WHERE TABLE_SCHEMA = '#{args['database']}'" )

  count = 0
  while (rsS.next) do
    next if rsS.getObject('TABLE_NAME') == 'schema_migrations' || rsS.getObject('TABLE_NAME') == 'play_evolutions'
 
    comment = rsS.getObject('TABLE_COMMENT') || ""
	
    puts rsS.getObject('TABLE_NAME') + " " + comment

    comment = comment.gsub(/\r/," ") 
    comment = comment.gsub(/\n/," ") 

    result['schema'][rsS.getObject('TABLE_NAME')] = {'columns' => {}, 'has_many' => Array.new, 'belongs_to' => Array.new, 'comment' => comment}

    columns = colSelect.execute_query("SELECT #{column_fields} FROM COLUMNS WHERE TABLE_SCHEMA = '#{args['database']}' AND TABLE_NAME = '#{rsS.getObject('TABLE_NAME')}'" )

    while (columns.next) do
      result['schema'][rsS.getObject('TABLE_NAME')]['columns'][columns.getObject('column_name')] = col
    end

  end

  tables.each do |row|
    next if row['TABLE_NAME'] == 'schema_migrations' || row['TABLE_NAME'] == 'play_evolutions'

    foreigns = client.query("SELECT #{rel_columns} FROM KEY_COLUMN_USAGE WHERE TABLE_SCHEMA = '#{args['database']}' AND TABLE_NAME = '#{row['TABLE_NAME']}' ")

    foreigns.each do |rel|
      # ignore primary key columns that dont reference anything
      next if rel['referenced_column_name'] == nil
     
      # add the has_many to the parent and the belongs_to to the child
      #puts "add has_many #{row['TABLE_NAME']} to #{rel['referenced_table_name']} " + rel.inspect
      result['schema'][rel['referenced_table_name']]['has_many'] = [] if result['schema'][rel['referenced_table_name']]['has_many'].nil?
      result['schema'][row['TABLE_NAME']]['belongs_to'] = [] if result['schema'][row['TABLE_NAME']]['belongs_to'].nil?
      
      result['schema'][rel['referenced_table_name']]['has_many'] << [row['TABLE_NAME']] 
      result['schema'][row['TABLE_NAME']]['belongs_to'] << [rel['referenced_table_name']] 
      
      # add the FK reference to the column
      result['schema'][row['TABLE_NAME']]['columns'][rel['column_name']]['references'] = "#{rel['referenced_table_name']}.#{rel['referenced_column_name']}"
    end

  end
  
  #puts result['schema']['companies']['columns']['user_id'].inspect
  # Close off the connection
  stmtSelect.close
  colSelect.close
  connSelect.close

  filename = args['database']
  case args['format']
    when :yaml
      filename = filename + '_column_info.yml'
    when :json
      filename = filename + '_column_info.json'
    end

  # generate the output
  File.open(filename,"w") do |f|
    case args['format']
    when :yaml
      f.write(result.to_yaml)
    when :json
      f.write(result.to_json)
    end
  end
end