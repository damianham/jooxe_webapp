module Jooxe
  
  # base class for all controllers, provides the CRUD operations for models
  # the return value from all methods in this class should be a Jooxe::View object
  
  class Controller
    
    attr_writer :env
  
    def index
      
      @collection = get_collection
      
      render  :collection => @collection
    end
    
    def show
     
      @instance = get_instance(route_info[:id])
      #puts "instance == " + @instance.inspect
      render  :instance => @instance
    end
    
    def edit
       
      @instance = get_instance(route_info[:id])
      
      render  :instance => @instance
    end
    
    def add
      # display the create form
      @instance = route_info[:model_class]
      render  :instance => @instance
    end
    
    def create
      puts "env == " + @env.inspect
      # insert the new instance
      get_dataset.insert(params)
      redirect_to :index
    end
    
    def update
      @instance = get_instance(route_info[:id])
      
      @instance.update(params)
      render  :instance => @instance
    end
    
    def destroy
      dataset = get_dataset
      
      dataset.where(:id => params[:id]).delete
    end
    
    private
    
    def params
      @env[:request].params
    end
    
    def route_info
      @env[:route_info]
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
    
    def get_dataset
      
      model_class = route_info[:model_class]
      dataset = nil
      
      if model_class.respond_to?(:all)
        dataset = model_class.all
      elsif model_class.respond_to?(:dataset)
        dataset = model_class.dataset
      else
        table_name = model_class.table_name || route_info[:table_name]
        
        dataset = DB[table_name.to_sym]
      end
      
      dataset
    end
    
    def get_collection(where = {})
      dataset = get_dataset
      
      
    end
    
    def get_instance(id)
      
      # get the dataset for the model class
      dataset = get_dataset
  
      # select the data record with the given ID
      model_data = dataset[:id => id]
      
      model_class = route_info[:model_class].class.new()
      
      if model_data.nil?
        # not found so return nil
        return nil
      end
      
      # create a new instance of the model class with the data result
      model_class.set_values(model_data)
      
      return model_class
      
    end
  end
end