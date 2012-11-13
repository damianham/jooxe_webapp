module Jooxe
  
  # base class for all controllers, provides the CRUD operations for models
  # the return value from all methods in this class should be a Jooxe::View object
  
  class Controller
    
    def env=(env)
      @env = env
      self
    end
    
    def params
      @env[:request].params
    end
    
    def route_info
      @env[:route_info]
    end
    
    def render(options = {})
     
       # render a collection of objects
      if ! @collection.nil? && ! options.has_key(:collection)
        options[:collection] = @collection
      end
      # or an instance
      if ! @instance.nil? && ! options.has_key?(:instance)
        options[:instance] = @instance
      end
      # ensure the action is setup
      if ! options.has_key?(:action)
        options[:action] = route_info[:action]
      end
      
      # the return value from this function is a Jooxe::View object      
      Jooxe::View.new(@env,self,options)
     
    end
    
    def index
      @collection = route_info[:model_class].class.dataset
      
      render  :collection => @collection
    end
    
    def show
      instance_id = route_info[route_info[:class_name].to_s+'_id'] 
      @instance = route_info[:model_class][instance_id]
      
      render  :instance => @instance
    end
    
    def edit
      instance_id = route_info[route_info[:class_name].to_s+'_id'] 
      @instance = route_info[:model_class][instance_id]
      
      render  :instance => @instance
    end
    
    def add
      # display the create form
      @instance = route_info[:model_class]
      render  :instance => @instance
    end
    
    def create
      # insert the new instance
      route_info[:model_class].dataset.insert(params)
      redirect_to :index
    end
  end
end