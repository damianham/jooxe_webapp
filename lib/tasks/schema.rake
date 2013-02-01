

require 'rubygems'
require 'yaml'
require 'mysql2'

desc "Build the schema"

# to specify default values,
# we take advantage of args being a Rake::TaskArguments object
task :build_schema, :database, :username, :password do |t, args|
  args.with_defaults( :username => "test", :password => "test",  :format => :yaml)
  puts "Args with defaults were: #{args}"

  rel_columns = "column_name,referenced_table_schema,referenced_table_name,referenced_column_name"
  column_fields = "column_name,ordinal_position,data_type,is_nullable,character_maximum_length,numeric_precision,column_comment"
  result = {'schema' => {}}

  # create the schema object then export to a yaml file

  client = Mysql2::Client.new(:host => "localhost", :username => args['username'],
  :password => args['password'], :database => 'information_schema')

  tables = client.query("SELECT TABLE_NAME,TABLE_COMMENT FROM TABLES WHERE TABLE_SCHEMA = '#{args['database']}'" )

  count = 0
  tables.each do |row|
    next if row['TABLE_NAME'] == 'schema_migrations' || row['TABLE_NAME'] == 'play_evolutions'
 
	comment = row['TABLE_COMMENT'] || ""
	
    puts row['TABLE_NAME'] + " " + comment

	comment = comment.gsub(/\r/," ") 
	comment = comment.gsub(/\n/," ") 

    result['schema'][row['TABLE_NAME']] = {'columns' => {}, 'has_many' => Array.new, 'belongs_to' => Array.new, 'comment' => comment}

    columns = client.query("SELECT #{column_fields} FROM COLUMNS WHERE TABLE_SCHEMA = '#{args['database']}' AND TABLE_NAME = '#{row['TABLE_NAME']}'" )

    columns.each do |col|
      result['schema'][row['TABLE_NAME']]['columns'][col['column_name']] = col
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
     
      result['schema'][rel['referenced_table_name']]['has_many'] << [row['TABLE_NAME']] 
      result['schema'][row['TABLE_NAME']]['belongs_to'] << [rel['referenced_table_name']] 
      
      # add the belongs_to to this child
      result['schema'][row['TABLE_NAME']]['columns'][rel['column_name']]['references'] = "#{rel['referenced_table_name']}.#{rel['referenced_column_name']}"
    end

  end
  
  client.close

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

