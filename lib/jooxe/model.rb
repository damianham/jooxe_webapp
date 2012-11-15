require 'sequel'

module Jooxe
  
  # base class for all models
  class Model < Sequel::Model
    
    attr_writer :env
    attr_accessor :table_name
    
    def params
      @env[:request].params
    end

  end
end

