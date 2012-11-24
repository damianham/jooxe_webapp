require 'spec_helper'

module Jooxe
  

    
  describe Path do
    
    # include the path helper
    include Jooxe::Path
  
    before(:all) do
      $dbs = nil
      Jooxe::Loader.load_databases 'test/db/*.yml'
    end
    
    before(:each) do
      @router = Router.new 
      @env = Hash.new
    end
    
    it "should generate /users/index when using action index with a class of User" do
      path = path_for_action(Jooxe::User, :index)
      path.should eq('/users/index')
    end
    
    it "should generate /users when action is nil with a class of User" do
      path = path_for_action(Jooxe::User)
      path.should eq('/users')
    end
    
    it "should generate /user/:id when action is show with an instance of User" do
      path = path_for_action(Jooxe::User.new(:id => 1),:show)
      path.should eq('/user/1/show')
    end
    
    it "should generate /user/:id when action is nil with an instance of User" do
      path = path_for_action(Jooxe::User.new(:id => 1))
      path.should eq('/user/1')
    end
    
    it "should generate /user/:id/edit when action is edit with an instance of User" do
      path = path_for_action(Jooxe::User.new(:id => 1),:edit)
      path.should eq('/user/1/edit')
    end
    
  end
end
