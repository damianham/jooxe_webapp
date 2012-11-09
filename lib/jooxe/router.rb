
module Jooxe
  

  class Router
 
  
=begin
  decode path into [database]/class[/id][/action]
  or with a nested path
  decode path into [database]/class/id/class[/id][/action]

=end
 
    def route(env)
      path = env["PATH_INFO"]
    
      @env = env
    
      path_elements = path.split('/')
    
      while path_elements[0] == ''
        path_elements.shift
      end
    
      return {:root => true} if path_elements.length == 0
    
      @database_name = consume_context(path_elements)
    
      # use the default database if no prefix given
      @database = $dbs[@database_name] || $dbs['default'] || {}
    
      #puts "after consume database paths == " + path_elements.inspect
      @route_info = Hash.new(:database => @database,
        :database_name => @database_name)
      
      while path_elements.length > 0
        class_name = id = action = nil
        #puts "before consume_class paths == " + path_elements.inspect
        @route_info[:class_name] = consume_class(path_elements)
        @route_info[:controller_class] = @controller_class
        @route_info[:model_class] = @model_class

        #puts "after consume_class class:#{@class_name} id:#{@id} action:#{@action} "  + path_elements.inspect
        id = consume_id(path_elements)
        #puts "after consume_id class:#{@class_name} id:#{@id} action:#{@action} "  + path_elements.inspect
        action = consume_action(path_elements)

        if action.nil? and ! id.nil?
          action = 'show'
        elsif action.nil? and id.nil?
          action = 'index'
        end
      
        @route_info.update!({ :id => id, :action => action })
        
        puts "after consume_action class:#{@route_info[:class_name]} id:#{id} action:#{action} " + path_elements.inspect
      
        @route_info[@route_info[:class_name].to_s+'_id'] = id unless @route_info[:class_name].nil? or id.nil?
      
      end
    
      @route_info
    
    end

    def consume_context(paths)
      if $dbs.has_key?(paths[0]) 
        paths.shift
      end
    end
  
    def consume_class(paths)
      return nil if paths[0].nil?
    
      # try to load the class 
      class_name = ($context.nil? ? '' : $context.camel_case) + paths[0].camel_case + 'Controller'
      
      begin 
        new_class = nil
        puts "consume_class loading @controller_class = Jooxe::#{class_name}.new"
        eval "@controller_class = Jooxe::#{class_name}.new"
        
      rescue NameError => boom
        puts boom.inspect 
        # loading the class failed try the database schema and use the delegate
        if @database.has_key?(paths[0])
          @controller_class = Jooxe::DynamicClassCreator.createController(@env.merge(:route_info => @route_info),class_name)
        end
      end
      if @controller_class.class.nil?
        raise "unknown class #{class_name}"
      end
      
      # dynamically create the model
      class_name = ($context.nil? ? '' : $context.camel_case) + paths[0].camel_case
      begin
        puts "consume_class loading @model_class = Jooxe::#{class_name}.new"
        eval "@model_class = Jooxe::#{class_name}.new"
      rescue NameError => boom
        puts boom.inspect 
        # loading the class failed try the database schema and use the delegate
        if @database.has_key?(paths[0])
          @model_class = Jooxe::DynamicClassCreator.createModel(@env.merge(:route_info => @route_info),class_name)
        end
      end
      
      @controller_class.env=@env.merge(:route_info => @route_info)
      @model_class.env = @env.merge(:route_info => @route_info)
      
      return paths.shift
      
    end
  
    def consume_id(paths)
      return nil if paths[0].nil?
    
      # the result could be a numeric ID /^\d+$/

      return paths.shift if paths[0] =~ /^\d+$/
    
      # IDs generated by SecureRandom.urlsafe_base64 (rfc 3584) are usually 4/3 of 16 bytes or more
      # a UUID generated by SecureRandom.uuid  is a v4 Random UUID (rfc 4112) 5 groups of chars 8-4-4-4-12
    
      return nil unless paths[0].length > 16
    
      # if there is any number in the path element then it is an ID
      if paths[0] =~ /\d/
        return paths.shift
      end
    end
  
    def consume_action(paths)
      return nil if paths[0].nil?
    
      # if the element is a known class we cannot consider it an action
      return nil if @database.has_key?(paths[0])

      # check if it is a method that can be performed on the current class
      # for the last element in the path
      if paths.length ==1
        if ! @controller_class.nil? && @controller_class.respond_to?(paths[0].to_sym)
          return paths.shift
        end 
      end
   
    end
  
  end

end