require 'spec_helper'

module Jooxe
  
  describe Model do
    before(:all) do
      $dbs = nil
      Jooxe::Loader.load_databases 'test/db/*.yml'
    end
    
    before(:each) do
      @router = Router.new 
      @env = Hash.new
    end
    
    it "should return the ID for to_param" do
      model = Jooxe::User.new(:id => 17)
      model.to_param.should eq("17")
    end
    
    
  end
end
