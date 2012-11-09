module Jooxe
  
  # base class for all models
  class Model < Sequel::Model
    
    def env=(env)
      @env = env
      self
    end
    
    def params
      @env[:params]
    end

  end
end

