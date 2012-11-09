require "yaml"

 # load the configuration
require 'config/jooxe'
    
require 'jooxe/framework'

class JooxeApplication
             

  def initialize
    puts "initializing jooxe"
    
    @router = Jooxe::Router.new

    # load controllers and models
    
    Dir.glob('app/models/*.rb') do |f|
      require f
      
      model_name = File.basename(f,'.rb')
      # define a controller for this model
      class_name = ($context.nil? ? '' : $context.camel_case) + model_name.to_s.camel_case + 'Controller'
    
      puts "create controller for model #{model_name} "
      Jooxe.module_eval "class #{class_name} < Jooxe::Controller; end"  
      
    end
    
    Dir.glob('app/controllers/*.rb') do |f|
      require f
    end
    
    $dbs = Hash.new 
  
    Dir.glob('db/*.yml') do |yml_file|
      # load the database definitions
      
      file_name = yml_file.gsub('db/','').split('_')[0]
      $dbs[file_name] = YAML::load( File.open( yml_file ) )['schema']
      
      #puts yml_file + " with filename " + file_name
      # define a controller for every table
      $dbs.each { |database_name,tables|  
        tables.each_key { |key|  
          class_name = ($context.nil? ? '' : $context.camel_case) + key.to_s.camel_case + 'Controller'
    
          puts "class #{class_name} < Jooxe::Controller; end"
          Jooxe.module_eval "class #{class_name} < Jooxe::Controller; end"          
        }
         
      }
    end
    
  end  
  
  
  def call(env)   
    
    # decode path into class,id,action
    options = @router.route(env)
    
#    begin
#      
#    rescue SyntaxError, NameError, RuntimeError, StandardError => rte
#      puts rte.inspect
#      return [404,{"Content-Type" => "text/html"}, Rack::Response.new("class not found")]
#    end
#    
    env[:route_info] = options
    
    view = Jooxe::View.new(env)
    
    if options[:class_name].nil?
      # root URL
      return [200, {"Content-Type" => "text/html"}, Rack::Response.new(view.render_path('root'))]
    end
   
    
    # create an instance of the class 
    begin 
      new_class = nil
      class_name = options[:class_name]
      action = options[:action]
      database_name = options[:database_name]
      params = options[:params]
      id = options[:id]
      @current_class = options [:controller_class]
      
      outp = "db:#{database_name} class:#{class_name} id:#{id} action:#{action} " 
    
      if ! @current_class.nil? && @current_class.respond_to?(action.to_sym)
        @current_class.send(action.to_sym)
      else
        [200, {"Content-Type" => "text/html"}, Rack::Response.new("Hello Rack! at #{outp}")]
      end
    end
 
  end
  
  
end 

