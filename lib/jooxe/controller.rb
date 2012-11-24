module Jooxe
  
  # base class for all controllers, provides the CRUD operations for models
  # the return value from all methods in this class should be a Jooxe::View object
  
  class Controller
    
    # include the path helper
    include Jooxe::Path
    
    attr_writer :env
  
    def index
      
      @collection = get_collection
      
      #puts "index collection == " + @collection.inspect
      
      render  :collection => @collection
    end
    
    def show
     
      @instance = get_instance(params[:id])
      #puts "instance == " + @instance.inspect
      render  :instance => @instance
    end
    
    def edit
       
      @instance = get_instance(params[:id])
      
      render  :instance => @instance
    end
    
    def add
      # display the create form
      @instance = route_info[:model_class]
      render  :instance => @instance
    end
    
    def create
      #puts "create params == " + params["user"].inspect
      # insert the new instance
      id = get_dataset.insert(params[class_name])
      @instance = get_instance(id)
      #puts "create instance == " + @instance.inspect
      redirect_to :index
    end
    
    def update
      
      @instance = get_instance(params[:id])
      
#      puts "update instance == " + @instance.inspect
#      puts "with " + params[class_name].inspect
      
      @instance.update(params[class_name])
      render  :instance => @instance
    end
    
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
        path = path_for_action(@instance || route_info[:model_class], path_or_sym_or_hash)
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
      
      view = Jooxe::View.new(@env,self,options.merge({:redirect_to => path.to_s}))
    end
    
    def get_dataset(options = nil)
      
      #model_class = 
      
      if options.nil? || ! options.is_a?(Hash)
        dataset = route_info[:model_class].class.dataset
      else
        dataset = route_info[:model_class].class.dataset.where(options)
      end
      
      yield dataset  if block_given?

      
      #      if model_class.respond_to?(:all)
      #        dataset = model_class.all
      #      elsif model_class.respond_to?(:dataset)
      #        dataset = model_class.dataset
      #      else
      #        table_name = model_class.table_name || route_info[:table_name]
      #        
      #        dataset = DB[table_name.to_sym]
      #      end
      
      dataset
      
    end
    
    def get_collection(where = nil)
      dataset = get_dataset(where)
      
      if block_given?
        dataset = yield dataset
      end
        
      dataset
    end
    
    def get_instance(id) 
      route_info[:model_class].class[id]
    end
    
  end
end