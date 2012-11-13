module Jooxe
  
  # base class for all controllers, provides the CRUD operations for models
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
    
    def requested_formats
      # "HTTP_ACCEPT"=>"text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8"
      # get the requested formats from HTTP_ACCEPT
      @env["HTTP_ACCEPT"].split(',').map { |x| 
        case x
        when /html$/
          'html'
        when /xml$/
          'xml'
        when /json$/
          'json'
        else
          nil
        end
      }.compact
    end
    
    def render_collection(options = {})
      # render a collection of objects
      
      # the return value from this function is a TemplateRendering object      
      TemplateRenderer.new(:collection => options[:collection] || @collection, 
        :action => options[:action] || route_info[:action])
     
    end
    
    def render_instance(options = {})
         # render a single instance of an object
      
      # the return value from this function is a TemplateRendering object
      TemplateRenderer.new(:instance => options[:instance] || @instance, 
        :action => options[:action] || route_info[:action])
     
    end
    
    def index
      @collection = route_info[:model_class].class.dataset
      
      render_collection 
    end
    
    def show
      instance_id = route_info[route_info[:class_name].to_s+'_id'] 
      @instance = route_info[:model_class][instance_id]
      
      render_instance
    end
    
    def edit
      instance_id = route_info[route_info[:class_name].to_s+'_id'] 
      @instance = route_info[:model_class][instance_id]
      
      render_form
    end
    
    def add
      # display the create form
      @instance = route_info[:model_class]
      render_form
    end
    
    def create
      # insert the new instance
      route_info[:model_class].dataset.insert(params)
      redirect_to :index
    end
  end
end