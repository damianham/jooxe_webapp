require 'spec_helper'

module Jooxe
  
  describe DynamicClassCreator do
    before(:all) do
      $dbs = nil
      Jooxe::Loader.load_databases 'test/db/*.yml'
    end
    
    before(:each) do
      @router = Router.new 
      @env = Hash.new
    end
    
  end
end
