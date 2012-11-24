require 'spec_helper'

module Jooxe
  describe Router do
  
    before(:all) do
      $dbs = nil
      # load all test databases
      Jooxe::Loader.load_databases 'test/db/*.yml'
    end
    
    before(:each) do      
      @router = Router.new #'test/db/*.yml'
      @env = Hash.new
    end  
    
    # now do all that with plural table names using the 
   it "should route to top level index" do
      @env["PATH_INFO"] = "/prefix/"
      options = @router.route(@env)
      options[:root].should eq(true)
    end
    
    it "should route to a controller index" do
      @env["PATH_INFO"] = "/prefix/site"
      options = @router.route(@env)
      options[:model_class_name].should eq('Site')
      options[:table_name].should eq('site')
      options[:controller_class].should be_an_instance_of(SitesController)
      options[:action].should eq('index')
    end
   
    it "should route to a controller action to view an instance" do
      @env["PATH_INFO"] = "/prefix/site/123"
      options = @router.route(@env)
      options[:model_class_name].should eq('Site')
      options[:table_name].should eq('site')
      options[:controller_class].should be_an_instance_of(SitesController)
      options[:action].should eq('show')
      options[:params][:id].should eq('123')
    end
    
    it "should route to a controller action" do
      @env["PATH_INFO"] = "/prefix/site/123/edit"
      options = @router.route(@env)
      options[:model_class_name].should eq('Site')
      options[:table_name].should eq('site')
      options[:controller_class].should be_an_instance_of(SitesController)
      options[:action].should eq('edit')
      options[:params][:id].should eq('123')
    end
    
    it "should route to a nested controller index" do
      @env["PATH_INFO"] = "/prefix/site/123/prefix_user"
      options = @router.route(@env)
      options[:model_class_name].should eq('PrefixUser')
      options[:table_name].should eq('prefix_user')
      options[:controller_class].should be_an_instance_of(PrefixUsersController)
      options[:action].should eq('index')
      options[:params][:site_id].should eq('123')
    end
    
    it "should route to a nested controller action to view an instance" do
      @env["PATH_INFO"] = "/prefix/site/123/prefix_user/456"
      options = @router.route(@env)
      options[:model_class_name].should eq('PrefixUser')
      options[:table_name].should eq('prefix_user')
      options[:controller_class].should be_an_instance_of(PrefixUsersController)
      options[:action].should eq('show')
      options[:params][:site_id].should eq('123')
      options[:params][:id].should eq('456')
    end
    
    it "should route to a nested controller action" do
      @env["PATH_INFO"] = "/prefix/site/123/prefix_user/456/edit"
      options = @router.route(@env)
      options[:model_class_name].should eq('PrefixUser')
      options[:table_name].should eq('prefix_user')
      options[:controller_class].should be_an_instance_of(PrefixUsersController)
      options[:action].should eq('edit')
      options[:params][:site_id].should eq('123')
      options[:params][:id].should eq('456')
    end
    
    
  end
end
