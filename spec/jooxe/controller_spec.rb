require 'spec_helper'

module Jooxe
  
  describe Controller do
    
    before(:all) do
      $dbs = nil
      Jooxe::Loader.load_databases 'test/db/plural*.yml'
    end
    
    before(:each) do
      @router = Router.new 
      @env = Hash.new
    end
    
    # we need to setup fixture data in order to test the controller methods
    
    it "should render a collection when calling index" do
      @env["PATH_INFO"] = "/users"
      options = @router.route(@env)
      options[:model_class_name].should eq('User')
      options[:table_name].should eq('users')
      options[:controller_class].should be_an_instance_of(UsersController)
      options[:action].should eq('index')
      
      view = options[:controller_class].send(:index)
      view.should be_an_instance_of(Jooxe::View)
      view.collection.all.size.should eq(3)
    end
    
    it "should render an instance when calling show" do
      @env["PATH_INFO"] = "/users/1"
      options = @router.route(@env)
      options[:model_class_name].should eq('User')
      options[:table_name].should eq('users')
      options[:controller_class].should be_an_instance_of(UsersController)
      options[:action].should eq('show')
      
      view = options[:controller_class].send(:show)
      view.should be_an_instance_of(Jooxe::View)
      view.instance.should be_an_instance_of(User)
      view.instance.id.should eq(1)
    end
  end
  
end
