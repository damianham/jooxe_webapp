require 'spec_helper'



module Jooxe
  describe Router do
  
    before(:all) do
      $dbs = nil
      Jooxe::Loader.load_databases 'test/db/default*.yml'
    end
    
    before(:each) do
      @router = Router.new 
      @env = Hash.new
    end
    
    it "should route to top level index" do
      @env["PATH_INFO"] = "/"
      options = @router.route(@env)
      options[:root].should eq(true)
    end
    
    it "should route to a controller index" do
      @env["PATH_INFO"] = "/user"
      options = @router.route(@env)
      options[:context_prefix].should eq ('/')
      options[:model_class_name].should eq('User')
      options[:table_name].should eq('user')
      options[:controller_class].should be_an_instance_of(UsersController)
      options[:action].should eq('index')
    end
   
    it "should route to a controller action to view an instance" do
      @env["PATH_INFO"] = "/user/123"
      options = @router.route(@env)
      options[:context_prefix].should eq ('/')
      options[:model_class_name].should eq('User')
      options[:table_name].should eq('user')
      options[:controller_class].should be_an_instance_of(UsersController)
      options[:action].should eq('show')
      options[:params][:id].should eq('123')
    end
    
    it "should route to a controller action" do
      @env["PATH_INFO"] = "/user/123/edit"
      options = @router.route(@env)
      options[:context_prefix].should eq ('/')
      options[:model_class_name].should eq('User')
      options[:table_name].should eq('user')
      options[:controller_class].should be_an_instance_of(UsersController)
      options[:action].should eq('edit')
      options[:params][:id].should eq('123')
    end
    
    it "should route to a nested controller index" do
      @env["PATH_INFO"] = "/user/123/post"
      options = @router.route(@env)
      options[:context_prefix].should eq ('/user/123')
      options[:model_class_name].should eq('Post')
      options[:table_name].should eq('post')
      options[:controller_class].should be_an_instance_of(PostsController)
      options[:action].should eq('index')
      options[:params][:user_id].should eq('123')
    end
    
    it "should route to a nested controller action to view an instance" do
      @env["PATH_INFO"] = "/user/123/post/456"
      options = @router.route(@env)
      options[:context_prefix].should eq ('/user/123')
      options[:model_class_name].should eq('Post')
      options[:table_name].should eq('post')
      options[:controller_class].should be_an_instance_of(PostsController)
      options[:action].should eq('show')
      options[:params][:user_id].should eq('123')
      options[:params][:id].should eq('456')
    end
    
    it "should route to a nested controller action" do
      @env["PATH_INFO"] = "/user/123/post/456/edit"
      options = @router.route(@env)
      options[:context_prefix].should eq ('/user/123')
      options[:model_class_name].should eq('Post')
      options[:table_name].should eq('post')
      options[:controller_class].should be_an_instance_of(PostsController)
      options[:action].should eq('edit')
      options[:params][:user_id].should eq('123')
      options[:params][:id].should eq('456')
    end
    
   
    
    it "should raise an error with an invalid class index" do
      @env["PATH_INFO"] = "/dummydumdum"
      expect { options = @router.route(@env)}.to raise_error(NameError,"Class not found DummydumdumsController")
    end
    
    it "should raise an error with an invalid class action" do
      @env["PATH_INFO"] = "/dummydumdum/123/edit"
      expect { options = @router.route(@env)}.to raise_error(NameError,"Class not found DummydumdumsController")
    end
    
    it "should raise an error with an invalid nested class" do
      @env["PATH_INFO"] = "/user/123/dummydumdum"
      expect { options = @router.route(@env)}.to raise_error(NameError,"Class not found DummydumdumsController")
    end
    
    it "should raise an error with an invalid action" do
      @env["PATH_INFO"] = "/user/123/dummydumdum"
      expect { options = @router.route(@env)}.to raise_error(NameError,"Class not found DummydumdumsController")
    end
    
    it "should raise an error with an invalid nested class action" do
      @env["PATH_INFO"] = "/user/123/post/456/dummydumdum"
      expect { options = @router.route(@env)}.to raise_error(NameError,"Class not found DummydumdumsController")
    end
    

  end
end
