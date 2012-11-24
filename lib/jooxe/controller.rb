module Jooxe
  
  # base class for all controllers, provides the CRUD operations for models
  # the return value from all methods in this class should be a Jooxe::View object
  
  class Controller
    
    # include the path helper
    include Jooxe::Path
    
    attr_writer :env
  
    # Get and render a collection of all instance of the model class 
    def index
      
      @collection = get_collection
      
      render  :collection => @collection
    end
    
    # Get and render a single instance of the model class
    def show
     
      @instance = get_instance(params[:id])

      render  :instance => @instance
    end
    
    # Get and render a single instance of the model class in a web form
    def edit
       
      @instance = get_instance(params[:id])
      
      render  :instance => @instance
    end
    
    # Create a new empty instance of the model class and render in a web form
    def add
      # display the create form
      @instance = route_info[:model_class]
      
      render  :instance => @instance
    end
    
    # Creates a new instance with the params values for the model class 
    # and saves it.
    # 
    # redirects to the class index
    def create
      # insert the new instance
      id = get_dataset.insert(params[class_name])
      
      @instance = get_instance(id)

      redirect_to :index
    end
    
    # Update and render a single instance of the model class
    # with the params values for the model class name
    def update
      
      @instance = get_instance(params[:id])
      
      @instance.update(params[class_name])
      
      render  :instance => @instance
    end
    
    # Delete an instance for the given ID in params[:id]
    # 
    # redirects to the class index
    def destroy
      dataset = get_dataset
      
      dataset.where(:id => params[:id]).delete
      
      redirect_to :index
    end
    
    private
    
    def params
      @env[:request].params.merge(route_info[:params])
    end
    
    def route_info
      @env[:route_info]
    end
    
    def class_name
      route_info[:model_class].class.name.demodulize.tableize.singularize
    end
    
    def render(options = {})
     
      # render a collection of objects
      if ! @collection.nil? && ! options.has_key?(:collection)
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
    
    def redirect_to(path_or_sym_or_hash)
      
      # actions are given by symbols
      options = {}
      path = path_or_sym_or_hash
      if path_or_sym_or_hash.is_a?(Symbol)
        # convert to a path for the action
        path = path_for_action(@instance || route_info[:model_class], path_or_sym_or_hash, route_info)
      elsif path_or_sym_or_hash.is_a?(Hash)
        path = path_or_sym_or_hash[:path]
        options = path_or_sym_or_hash
      end
      
      # ensure the options contain the class data
      if ! @collection.nil? && ! options.has_key?(:collection)
        options[:collection] = @collection
      end
 
      if ! @instance.nil? && ! options.has_key?(:instance)
        options[:instance] = @instance
      end
      
      Jooxe::View.new(@env,self,options.merge({:redirect_to => path.to_s}))
    end
    
    # get the base dataset for the class
    def get_dataset(options = nil)
      
      if options.nil? || ! options.is_a?(Hash)
        dataset = route_info[:model_class].class.dataset
      else
        dataset = route_info[:model_class].class.dataset.where(options)
      end
      
      dataset
      
    end
    
    # get a collection of records from the class dataset    
    def get_collection(where = nil)
      dataset = get_dataset(where)
      
      if block_given?
        dataset = yield dataset
      end
        
      dataset
    end
    
    # get a single instance of a record from the class dataset
    def get_instance(id) 
      route_info[:model_class].class[id]
    end
    
  end
end