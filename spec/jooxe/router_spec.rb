require 'spec_helper'
  
Dir.glob('test/db/*.yml') do |yml_file|
  # load the database definitions
      
  file_name = yml_file.gsub('db/','').split('_')[0]
  $dbs[file_name] = YAML::load( File.open( yml_file ) )['schema']
      
  #puts yml_file + " with filename " + file_name
  # define a controller for every table
  $dbs.each { |database_name,tables|  
    tables.each_key { |key|  
      class_name = ($context.nil? ? '' : $context.camel_case) + key.to_s.camel_case + 'Controller'
    
      Jooxe.module_eval "class #{class_name} < Jooxe::Controller; end"          
    }
         
  }
end

module Jooxe
  describe Router do
  
    it "should route to top level index" do
      router = Router.new
    
    end
  end
end
