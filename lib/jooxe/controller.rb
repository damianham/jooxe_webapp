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
    
    def index
      @collection = find(nil)
    end
    
    def show
      instance_id = params[params[:class_name].to_s+'_id'] 
      @instance = find({:where => {:id => instance_id}})
    end
    
    def find(options = {})
      
    end
    
    def edit
      instance_id = params[params[:class_name].to_s+'_id'] 
      @instance = find({:where => {:id => instance_id}})
    end
  end
end