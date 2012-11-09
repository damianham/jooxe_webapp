module Jooxe
  
  class DynamicClassCreator
    
    def DynamicClassCreator.createController(env,class_name)
      
      new_class = nil
      
      puts "DynamicClassCreator creating class #{class_name} < Jooxe::Controller; end"
      Jooxe.module_eval "class #{class_name} < Jooxe::Controller; end" 
      
      Jooxe.module_eval "new_class = #{class_name}.new"
      new_class
    end
    
    def DynamicClassCreator.createModel(env,class_name)
      
      new_class = nil
      
      puts "DynamicClassCreator creating class #{class_name} < Jooxe::Model; end"
      Jooxe.module_eval "class #{class_name} < Jooxe::Model; end" 
      
      Jooxe.module_eval "new_class = #{class_name}.new"
      new_class
    end
    
  end
end