require "yaml"

# load the configuration
require 'config/jooxe'
    
require 'jooxe/framework'

class JooxeApplication
             

  def initialize
    puts "initializing jooxe"
    
    @router = Jooxe::Router.new

    # load controllers and models
    Jooxe::Loader.load_models
    
    Jooxe::Loader.load_controllers 
  
    # load the database schema definitions
    Jooxe::Loader.load_databases
    
  end  
  
  
  def call(env)   
    
    req = Rack::Request.new(env)
    
    env[:request] = req

=begin    
    envstr = ''
    
    env.each_pair do |k,v|
      envstr << "#{k} == " + v.inspect + "</br>"
    end
    
    envstr << "<p> params == " + req.params.inspect
    
    return [200, {"Content-Type" => "text/html"}, Rack::Response.new("Hello Rack! at #{envstr}")]
=end
    
    # decode path into class,id,action
    options = @router.route(env)

    env[:route_info] = options
    
    if options[:class_name].nil?
      # root URL
      view = Jooxe::View.new(env)
      return [200, {"Content-Type" => "text/html"}, Rack::Response.new(view.render_path('root'))]
    end
    
    # create an instance of the class 
    begin 

      action = options[:action]

      params = options[:params]
      id = options[:id]
      @controller = options [:controller_class]
    
      view = @controller.send(action.to_sym)
      response = Rack::Response.new(view.render(options))
      [response.status, response.headers, response.body]
    end
 
  end
  
  
end 

