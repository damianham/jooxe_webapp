module Jooxe
  module Path
    
    # convert a class or instance and an action into a URI
    def path_for_action(object_or_class,action = nil,options = {})
      
      # get the context prefix - the parts of the PATH_INFO preceeding the current class
      context = options[:context_prefix] || ''
      # '/' means no context so set it to the empty string
      context = '' if context == '/'
      
      if action.nil?
        if object_or_class.is_a?(Class)
          # generate a path to the index for the class
          context + '/' + object_or_class.name.demodulize.tableize
        else  # it is an instance of a class 
          # generate a path to show the object instance
          context + '/' +object_or_class.class.name.demodulize.tableize.singularize + '/' + object_or_class.to_param
        end
      else
        
        if object_or_class.is_a?(Class)
          # generate a path to the given action for the class
          #puts "path_for_action #{action} is a Class with " + object_or_class.inspect
          context + '/' +object_or_class.name.demodulize.tableize + '/' + action.to_s
        elsif object_or_class.to_param.nil?
          #puts "path_for_action #{action} to_param == nil with " + object_or_class.inspect
          context + '/' +object_or_class.class.name.demodulize.tableize + (action.to_s == 'index' ? '' : '/'  + action.to_s)
        else
          #puts "path_for_action #{action} has ID with " + object_or_class.inspect
          context + '/' + object_or_class.class.name.demodulize.tableize.singularize + '/' + object_or_class.to_param + '/' + action.to_s
        end
      end
    end
  end
end
