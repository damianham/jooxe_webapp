module Jooxe
  class View
    
    def initialize(env,options = {})
      @env = env
      
      #puts "initialize View with " + options.inspect
    end
    
    def render_path(path)
      "hello from view"
    end
    
    def render_instance
      template_file = nil
      class_action_name = File.join(route_info[:class_name], route_info[:action])
      
      # try each requested format in turn until we find a view or template
      requested_formats.each { |format|
        
        # unless we have already found a requested template type
        if template_file.nil? 
          files = File.join("app","views", "**","#{class_action_name}.#{format}.*")

          template_file = Dir.glob(files)[0]
          
          if template_file.nil? 
            erbfiles = File.join("app","templates", "**","#{route_info[:class_name]}.#{format}.*")

            template_file = Dir.glob(erbfiles)[0]
            
          end
        
        end
      }
      
      # if we found a template file then render with it otherwise use the generic templates
      if template_file.nil?
        requested_formats.each { |format|
        
          # unless we have already found a requested template type
          if template_file.nil? 
            files = File.join("app","templates", "generic_instance.#{format}.*")

            template_file = Dir.glob(files)[0]       
          end
        }
      end
      
      render_with_template(template_file,@instance)
    end
    
    
    def render_instance
      template_file = nil
      class_action_name = File.join(route_info[:class_name], route_info[:action])
      
      # try each requested format in turn until we find a view or template
      requested_formats.each { |format|
        
        # unless we have already found a requested template type
        if template_file.nil? 
          files = File.join("app","views", "**","#{class_action_name}.#{format}.*")

          template_file = Dir.glob(files)[0]
          
          if template_file.nil? 
            erbfiles = File.join("app","templates", "**","#{route_info[:class_name]}.#{format}.*")

            template_file = Dir.glob(erbfiles)[0]
            
          end
        
        end
      }
      
      # if we found a template file then render with it otherwise use the generic templates
      if template_file.nil?
        requested_formats.each { |format|
        
          # unless we have already found a requested template type
          if template_file.nil? 
            files = File.join("app","templates", "generic_instance.#{format}.*")

            template_file = Dir.glob(files)[0]       
          end
        }
      end
      
      render_with_template(template_file,@instance)
    end
    
  end
end