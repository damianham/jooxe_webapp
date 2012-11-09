module Jooxe
  
  # base class for all controllers, provides the CRUD operations for models
  class Controller
    
    def env=(env)
      @env = env
      self
    end
    
    def params
      @env[:params]
    end
    
    def route_info
      @env[:route_info]
    end
    
    def index
      @collection = route_info[:model_class].all
      
      respond_to do |format|
        format.html render_collection
        format.xml render_collection_as_xml
        format.json render_collection_as_json
      end
    end
    
    def show
      instance_id = route_info[route_info[:class_name].to_s+'_id'] 
      @instance = route_info[:model_class][instance_id]
      respond_to do |format|
        format.html render
        format.xml render_as_xml
        format.json render_as_json
      end
    end
    
    def edit
      instance_id = route_info[route_info[:class_name].to_s+'_id'] 
      @instance = route_info[:model_class][instance_id]
      respond_to do |format|
        format.html render
        format.xml render_as_xml
        format.json render_as_json
      end
    end
    
    def add
      # display the create form
      respond_to do |format|
        format.html render
        format.xml render_as_xml
        format.json render_as_json
      end
    end
    
    def create
      # insert the new instance
      route_info[:model_class].dataset.insert(params)
      redirect_to :index
    end
  end
end