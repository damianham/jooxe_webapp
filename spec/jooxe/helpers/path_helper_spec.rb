require 'spec_helper'

module Jooxe
  
  describe Path do
    before(:all) do
      $dbs = nil
      Jooxe::Loader.load_databases 'test/db/*.yml'
    end
    
    before(:each) do
      @router = Router.new 
      @env = Hash.new
    end
    
    it "should generate /users when using action index with an instance of User" do
   
    end
    
    it "should generate /users when action is nil with an class of User" do
   
    end
    
    it "should generate /users/:id when action is show with an instance of User" do
   
    end
    
    it "should generate /users/:id when action is nil with an instance of User" do
   
    end
    
  end
end
