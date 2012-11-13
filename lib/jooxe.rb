require "yaml"

# load the configuration
require 'config/jooxe'
    
require 'jooxe/framework'

class JooxeApplication
             

  def initialize
    puts "initializing jooxe"
    
    @router = Jooxe::Router.new

    # load controllers and models
    Jooxe::Loader.loadModels
    
    Jooxe::Loader.loadControllers 
  
    Jooxe::Loader.loadDatabases
    
  end  
  
  
  def call(env)   
    
    envstr = env.inspect
    
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
    
    if options[:class_name].nil?
      # root URL
      view = Jooxe::View.new(env)
      return [200, {"Content-Type" => "text/html"}, Rack::Response.new(view.render_path('root'))]
    end
   
    env[:request] = Rack::Request.new(env)
    
    # create an instance of the class 
    begin 
      new_class = nil
      class_name = options[:class_name]
      action = options[:action]
      database_name = options[:database_name]
      params = options[:params]
      id = options[:id]
      @controller = options [:controller_class]
      
      outp = "db:#{database_name} class:#{class_name} id:#{id} action:#{action} " + envstr
    
      if ! @controller.nil? && @controller.respond_to?(action.to_sym)
        view = @controller.send(action.to_sym)
        response = Rack::Response.new(view.render(options))
        [response.status, response.headers, response.body]        
      else
        [200, {"Content-Type" => "text/html"}, Rack::Response.new("Hello Rack! at #{outp}")]
      end
    end
 
  end
  
  
end 

