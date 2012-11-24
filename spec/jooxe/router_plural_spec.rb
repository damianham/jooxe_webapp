require 'spec_helper'



module Jooxe
  describe Router do
  
    before(:all) do
      $dbs = nil
      Jooxe::Loader.load_databases 'test/db/plural*.yml'
    end
    
    before(:each) do      
      @router = Router.new #'test/db/*.yml'
      @env = Hash.new
    end  
    
    # now do all that with plural table names using the 
    
    it "should route to a pluralized controller index" do
      @env["PATH_INFO"] = "/posts"
      options = @router.route(@env)
      options[:model_class_name].should eq('Post')
      options[:table_name].should eq('posts')
      options[:action].should eq('index')
    end
    
    
    it "should route to a pluralized controller action to view an instance" do
      @env["PATH_INFO"] = "/posts/123"
      options = @router.route(@env)      
      options[:model_class_name].should eq('Post')
      options[:table_name].should eq('posts')
      options[:controller_class].should be_an_instance_of(PostsController)
      options[:action].should eq('show')
      options[:params][:id].should eq('123')
    end
    
    it "should route to pluralized a controller action" do
      @env["PATH_INFO"] = "/posts/123/edit"
      options = @router.route(@env)
      options[:model_class_name].should eq('Post')
      options[:table_name].should eq('posts')
      options[:action].should eq('edit')
      options[:params][:id].should eq('123')
    end
    
    it "should route to a pluralized nested controller index" do
      @env["PATH_INFO"] = "/posts/123/comments"
      options = @router.route(@env)
      options[:model_class_name].should eq('Comment')
      options[:table_name].should eq('comments')
      options[:action].should eq('index')
      options[:params][:post_id].should eq('123')
    end
    
    it "should route to a pluralized nested controller action to view an instance" do
      @env["PATH_INFO"] = "/posts/123/comments/456"
      options = @router.route(@env)
      options[:model_class_name].should eq('Comment')
      options[:table_name].should eq('comments')
      options[:action].should eq('show')
      options[:params][:post_id].should eq('123')
      options[:params][:id].should eq('456')
    end
    
    it "should route to a pluralized nested controller action" do
      @env["PATH_INFO"] = "/posts/123/comments/456/edit"
      options = @router.route(@env)
      options[:model_class_name].should eq('Comment')
      options[:table_name].should eq('comments')
      options[:action].should eq('edit')
      options[:params][:post_id].should eq('123')
      options[:params][:id].should eq('456')
    end
    

    

  end
end
