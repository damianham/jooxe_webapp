
module Jooxe
  
  class Loader
    
    def Loader.load_models(glob_pattern = 'app/models/*.rb')
      
      #puts "loading models with glob pattern == #{glob_pattern}"
      Dir.glob(glob_pattern) do |f|
        require f
      
        model_name = File.basename(f,'.rb')
        # define a controller for this model
        DynamicClassCreator.define_controller(model_name) 
      
      end
    end
    
    def Loader.load_controllers(glob_pattern = 'app/controllers/*.rb')
      
      #puts "loading controllers with glob pattern == #{glob_pattern}"
      Dir.glob(glob_pattern) do |f|
        require f
      end
    end
    
    def Loader.load_databases(glob_pattern = 'db/*.yml')
      
      $dbs = Hash.new if $dbs.nil?
    
      #puts "loading databases with glob pattern == #{glob_pattern}"
      Dir.glob(glob_pattern) do |yml_file|
        # load the database definitions
      
        file_name = yml_file.gsub('db/','').split('_')[0]
        $dbs[file_name] = YAML::load( File.open( yml_file ) )['schema']
      
        #puts yml_file + " with filename " + file_name

      end
      
      # define a controller for every table
      $dbs.each do |database_name,tables|  
        tables.each_key do |key|  
          DynamicClassCreator.define_controller(key)   
          DynamicClassCreator.define_model(key) 
        end
         
      end
      
    end
    
  end
  
  class DynamicClassCreator
    
    def DynamicClassCreator.define_controller(name)
      class_name = name.to_controller_name
    
      #puts "DynamicClassCreator creating controller class #{class_name} < Jooxe::Controller; end"
      Jooxe.module_eval "class #{class_name} < Jooxe::Controller; end" 
    end
    
    def DynamicClassCreator.define_model(name)
      class_name = name.to_model_name
       
      #puts "DynamicClassCreator creating model class #{class_name} < Jooxe::Model; end"
      Jooxe::module_eval "class #{class_name} < Jooxe::Model; end" 
      
    end
    
    
    def DynamicClassCreator.create_controller(env,name)
      
      self.define_controller(name)
      
      Jooxe::module_eval "new_class = #{name.to_controller_name}.new"
 
    end
    
    def DynamicClassCreator.create_model(env,name)
      
      #new_class = nil
      
      self.define_model(name)
      
      Jooxe::module_eval "new_class = #{name.to_model_name}.new"
      #new_class
    end
    
  end
end