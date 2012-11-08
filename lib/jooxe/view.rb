module Jooxe
  class View
    
    def initialize(env,options = {})
      @env = env
      
      #puts "initialize View with " + options.inspect
    end
    
    def render_path(path)
      "hello from view"
    end
  end
end