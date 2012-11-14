require 'spec_helper'

Jooxe::Loader.load_databases 'test/db/*.yml'

module Jooxe
  describe Router do
  
    before(:each) do
      @router = Router.new
      @env = Hash.new
    end
    
    it "should route to top level index" do
      @env["PATH_INFO"] = "/"
      options = @router.route(@env)
      options[:root].should eq(true)
    end
    
    it "should route to a pluralized controller index" do
      @env["PATH_INFO"] = "/user"
      options = @router.route(@env)
      options[:class_name].should eq('User')
      options[:action].should eq('index')
    end
    
    it "should route to a singularized controller index" do
      @env["PATH_INFO"] = "/user"
      options = @router.route(@env)
      options[:class_name].should eq('User')
      options[:action].should eq('index')
    end
    
    it "should route to a controller action to view an instance" do
      @env["PATH_INFO"] = "/user/123"
      options = @router.route(@env)
      options[:class_name].should eq('User')
      options[:action].should eq('show')
      options[:user_id].should eq('123')
    end
    
    it "should route to a controller action" do
      @env["PATH_INFO"] = "/user/123/edit"
      options = @router.route(@env)
      options[:class_name].should eq('User')
      options[:action].should eq('edit')
      options[:user_id].should eq('123')
    end
    
    it "should route to a nested controller index" do
      @env["PATH_INFO"] = "/user/123/user_group"
      options = @router.route(@env)
      options[:class_name].should eq('UserGroup')
      options[:action].should eq('index')
      options[:user_id].should eq('123')
    end
    
    it "should route to a nested controller action to view an instance" do
      @env["PATH_INFO"] = "/user/123/user_group/456"
      options = @router.route(@env)
      options[:class_name].should eq('UserGroup')
      options[:action].should eq('show')
      options[:user_id].should eq('123')
      options[:user_group_id].should eq('456')
    end
    
    it "should route to a nested controller action" do
      @env["PATH_INFO"] = "/user/123/user_group/456/edit"
      options = @router.route(@env)
      options[:class_name].should eq('UserGroup')
      options[:action].should eq('edit')
      options[:user_id].should eq('123')
      options[:user_group_id].should eq('456')
    end
    
    it "should raise an error with an invalid class index" do
      @env["PATH_INFO"] = "/dummydumdum"
      expect { options = @router.route(@env)}.to raise_error(NameError,"Class not found DummydumdumController")
    end
    
    it "should raise an error with an invalid class action" do
      @env["PATH_INFO"] = "/dummydumdum/123/edit"
      expect { options = @router.route(@env)}.to raise_error(NameError,"Class not found DummydumdumController")
    end
    
    it "should raise an error with an invalid nested class" do
      @env["PATH_INFO"] = "/user/123/dummydumdum"
      expect { options = @router.route(@env)}.to raise_error(NameError,"Class not found DummydumdumController")
    end
    
    it "should raise an error with an invalid action" do
      @env["PATH_INFO"] = "/user/123/dummydumdum"
      expect { options = @router.route(@env)}.to raise_error(NameError,"Class not found DummydumdumController")
    end
    
    it "should raise an error with an invalid nested class action" do
      @env["PATH_INFO"] = "/user/123/user_group/456/dummydumdum"
      expect { options = @router.route(@env)}.to raise_error(NameError,"Class not found DummydumdumController")
    end
  end
end
