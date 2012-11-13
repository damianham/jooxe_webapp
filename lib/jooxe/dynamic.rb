
puts "loading dynamic module"

module Jooxe
  
  class Loader
    
    def Loader.loadModels(glob_pattern = 'app/models/*.rb')
      
      puts "loading models with glob pattern == #{glob_pattern}"
      Dir.glob(glob_pattern) do |f|
        require f
      
        model_name = File.basename(f,'.rb')
        # define a controller for this model
        DynamicClassCreator.defineController(model_name) 
      
      end
    end
    
    def Loader.loadControllers(glob_pattern = 'app/controllers/*.rb')
      
      puts "loading controlelrs with glob pattern == #{glob_pattern}"
      Dir.glob(glob_pattern) do |f|
        require f
      end
    end
    
    def Loader.loadDatabases(glob_pattern = 'db/*.yml')
      
      $dbs = Hash.new if $dbs.nil?
    
      puts "loading databases with glob pattern == #{glob_pattern}"
      Dir.glob('db/*.yml') do |yml_file|
        # load the database definitions
      
        file_name = yml_file.gsub('db/','').split('_')[0]
        $dbs[file_name] = YAML::load( File.open( yml_file ) )['schema']
      
        #puts yml_file + " with filename " + file_name

      end
      
      # define a controller for every table
      $dbs.each do |database_name,tables|  
        tables.each_key do |key|  
          DynamicClassCreator.defineController(key)          
        end
         
      end
      
    end
    
  end
  
  class DynamicClassCreator
    
    def DynamicClassCreator.defineController(model_name)
      class_name = model_name.to_s.camel_case + 'Controller'
    
      puts "DynamicClassCreator creating class #{class_name} < Jooxe::Controller; end"
      Jooxe.module_eval "class #{class_name} < Jooxe::Controller; end" 
    end
    
    def DynamicClassCreator.defineModel(model_name)
      class_name = model_name.to_s.camel_case
       
      puts "DynamicClassCreator creating class #{class_name} < Jooxe::Model; end"
      Jooxe::module_eval "class #{class_name} < Jooxe::Model; end" 
      
    end
    
    
    def DynamicClassCreator.createController(env,model_name)
      
      self.defineController(model_name)
      
      Jooxe::module_eval "new_class = #{model_name}.new"
 
    end
    
    def DynamicClassCreator.createModel(env,model_name)
      
      #new_class = nil
      
      self.defineModel(model_name)
      
      Jooxe::module_eval "new_class = #{model_name}.new"
      #new_class
    end
    
  end
end