require 'erb'
require 'tilt'

module Jooxe
  class View
    
    def initialize(env,binding_context,options = {})
      @env = env
      @context = binding_context  # the controller that performed the action
      @options = options
      #puts "initialize View with " + options.inspect
    end
    
    def render_path(path)
      "hello from view"
    end
    
    def render(options = {})
      template_file = template_for_requested_format options
      
      render_template(template_file,options)
    end
    
    # render the given template 
    def render_template(template_file,options = {})
      
      # if no layout is specified in the options then get the layout
      # from the binding context
      if options[:layout].has_key?(:layout)
        layout = options[:layout]
      else
        layout = @context.layout
      end
      
      if layout.nil? || @preferred_format == 'json'
        # render the template without a layout
        render_template_raw(template_file,options)
      else
        # uhmmm render with a layout
        render_template_with_layout(layout,template_file,options)
      end
    end
    
    private
    
    def requested_formats
      # "HTTP_ACCEPT"=>"text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8"
      # get the requested formats from HTTP_ACCEPT
      formats = @env["HTTP_ACCEPT"].split(',').map { |x| 
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
      
      @preferred_format = formats[0]
      formats
    end
    
    def render_template_raw(template_file,options = {})
      template = Tilt.new(template_file)
      output = template.render(@context, options[:locals])
    end
    
    def render_template_with_layout(layout,template_file,options = {})
      template = Tilt.new(layout)
      output = template.render {
        render_template_raw(template_file,options)
      }
    end
    
    def template_for_requested_format(options = {})
      template_file = nil
      class_action_name = File.join(options[:class_name], options[:action])
      
      # try each requested format in turn until we find a view or template
      requested_formats.each { |format|
        
        # unless we have already found a requested template type
        if template_file.nil? 
          files = File.join("app","views", "**","#{class_action_name}.#{format}.*")

          template_file = Dir.glob(files)[0]
          
          if template_file.nil? 
            erbfiles = File.join("app","templates", "**","#{options[:class_name]}.#{format}.*")

            template_file = Dir.glob(erbfiles)[0]
            
          end
        
        end
      }
      
      # use the generic collection or instance template
      if template_file.nil?
        requested_formats.each { |format|
          template_type = options[:collection].nil? ? 'instance' : 'collection'
          # unless we have already found a requested template type
          if template_file.nil? 
            files = File.join("app","templates", "generic",  "#{template_type}.#{format}.*")

            template_file = Dir.glob(files)[0]       
          end
        }
      end
      
    end
    
  end
end