require 'spec_helper'

module Jooxe
  
  describe Controller do
    
    before(:all) do
      $dbs = nil
      Jooxe::Loader.load_databases 'test/db/plural*.yml'
    end
    
    before(:each) do
      @router = Router.new 
      @env = Hash.new(
 
        # setup some basic values in the env hash

        "GATEWAY_INTERFACE" => "CGI/1.1",
        "PATH_INFO" => "/helios/users",

        "REMOTE_ADDR" => "0:0:0:0:0:0:0:1",
        "REMOTE_HOST" => "0:0:0:0:0:0:0:1",
        "REQUEST_METHOD" => "GET",

        "SCRIPT_NAME" => "",
        "SERVER_NAME" => "localhost",
        "SERVER_PORT" => "9292",
        "SERVER_PROTOCOL" => "HTTP/1.1",
        "SERVER_SOFTWARE" => "WEBrick/1.3.1 (Ruby/1.9.2/2012-05-01)",
        "HTTP_HOST" => "localhost:9292",
        "HTTP_CONNECTION" => "keep-alive",
        "HTTP_CACHE_CONTROL" => "max-age=0",
        "HTTP_USER_AGENT" => "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.11 (KHTML, like Gecko) Chrome/23.0.1271.64 Safari/537.11",
        "HTTP_ACCEPT" => "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
        "HTTP_ACCEPT_ENCODING" => "gzip,deflate,sdch",
        "HTTP_ACCEPT_LANGUAGE" => "en-US,en;q=0.8",
        "HTTP_ACCEPT_CHARSET" => "ISO-8859-1,utf-8;q=0.7,*;q=0.3",
        "HTTP_RANGE" => "bytes=1458-1458",
        "HTTP_IF_RANGE" => "\"7406a4673c6917a581f234009cd95028\"",
        "rack.version" => [1, 1],
        #rack.input == #>,
        #rack.errors == #>,
        "rack.multithread" => false,
        "rack.multiprocess" => false,
        "rack.run_once" => false,
        "rack.url_scheme" => "http",
        "HTTP_VERSION" => "HTTP/1.1",
        "jooxe.request_id" => "13f37d89-90e6-4980-b805-4438737a2e75"
      )
     
      
      req = Rack::Request.new(@env)
      @env[:request] = req
    end
    
    # we need to setup fixture data in order to test the controller methods
    
    it "should retrieve a collection when calling index" do
      @env["PATH_INFO"] = "/users"
      # REQUEST_URI => "http://localhost:9292/helios/users?id=123&post[title]=Hello"
      # REQUEST_PATH = "/helios/users"
      options = @router.route(@env)
      options[:model_class_name].should eq('User')
      options[:table_name].should eq('users')
      options[:controller_class].should be_an_instance_of(UsersController)
      options[:action].should eq('index')
      
      view = options[:controller_class].send(options[:action])
      view.should be_an_instance_of(Jooxe::View)
      view.collection.all.size.should eq(3)
    end
    
    it "should retrieve an instance when calling show" do
      @env["PATH_INFO"] = "/users/1"
      options = @router.route(@env)
      options[:model_class_name].should eq('User')
      options[:table_name].should eq('users')
      options[:controller_class].should be_an_instance_of(UsersController)
      options[:action].should eq('show')
      
      #puts "model == " + options[:model_class].inspect
      
      view = options[:controller_class].send(options[:action])
      view.should be_an_instance_of(Jooxe::View)
      
      #puts "view == " + view.inspect
      
      view.instance.should be_an_instance_of(User)
      view.instance.id.should eq(1)
    end
    
    it "should retrieve an instance when calling edit" do
      @env["PATH_INFO"] = "/users/2/edit"
      options = @router.route(@env)
      options[:model_class_name].should eq('User')
      options[:table_name].should eq('users')
      options[:controller_class].should be_an_instance_of(UsersController)
      options[:action].should eq('edit')
      
      #puts "model == " + options[:model_class].inspect
      
      view = options[:controller_class].send(options[:action])
      view.should be_an_instance_of(Jooxe::View)
      
      #puts "view == " + view.inspect
      
      view.instance.should be_an_instance_of(User)
      view.instance.id.should eq(2)
    end
    
    it "should create an empty instance when calling add" do
      @env["PATH_INFO"] = "/users/add"
      options = @router.route(@env)
      options[:model_class_name].should eq('User')
      options[:table_name].should eq('users')
      options[:controller_class].should be_an_instance_of(UsersController)
      options[:action].should eq('add')
      
      #puts "model == " + options[:model_class].inspect
      
      view = options[:controller_class].send(options[:action])
      view.should be_an_instance_of(Jooxe::View)
      
      #puts "view == " + view.inspect
      
      view.instance.should be_an_instance_of(User)
      view.instance.id.should be_nil
      view.instance.mail.should be_nil
    end
    
    it "should create and render a new instance when calling create with action in path info" do
      @env["PATH_INFO"] = "/users/create"
      @env["QUERY_STRING"]   = "id=123&post[title]=Hello"
      
      options = @router.route(@env)
      options[:model_class_name].should eq('User')
      options[:table_name].should eq('users')
      options[:controller_class].should be_an_instance_of(UsersController)
      options[:action].should eq('create')
      
      #puts "model == " + options[:model_class].inspect
      
      view = options[:controller_class].send(options[:action])
      view.should be_an_instance_of(Jooxe::View)
      
      puts "instance == " + view.instance.inspect
      
      view.instance.should be_an_instance_of(User)
      view.instance.id.should eq(4)
    end
   
    it "should create and render a new instance when calling create with post verb" do
      @env["PATH_INFO"] = "/users"
      @env["REQUEST_METHOD"] = "POST"
      options = @router.route(@env)
      options[:model_class_name].should eq('User')
      options[:table_name].should eq('users')
      options[:controller_class].should be_an_instance_of(UsersController)
      options[:action].should eq('create')
      
      #puts "model == " + options[:model_class].inspect
      
      view = options[:controller_class].send(options[:action])
      view.should be_an_instance_of(Jooxe::View)
      
      puts "instance == " + view.instance.inspect
      
      view.instance.should be_an_instance_of(User)
      view.instance.id.should eq(5)
    end
    
    it "should delete an instance when calling destroy and redirect to index with action in path info" do
      @env["PATH_INFO"] = "/users/5/destroy"
      options = @router.route(@env)
      options[:model_class_name].should eq('User')
      options[:table_name].should eq('users')
      options[:controller_class].should be_an_instance_of(UsersController)
      options[:action].should eq('destroy')
      
      #puts "model == " + options[:model_class].inspect
      
      view = options[:controller_class].send(options[:action])
      view.should be_an_instance_of(Jooxe::View)
      
      #puts "view == " + view.inspect
      
      view.instance.should be_nil
      view.redirect_to.should eq('/users')
    end
    
       
    it "should delete an instance when calling destroy and redirect to index with delete verb" do
      @env["PATH_INFO"] = "/users/4"
      @env["REQUEST_METHOD"] = "DELETE"
      options = @router.route(@env)
      options[:model_class_name].should eq('User')
      options[:table_name].should eq('users')
      options[:controller_class].should be_an_instance_of(UsersController)
      options[:action].should eq('destroy')
      
      #puts "model == " + options[:model_class].inspect
      
      view = options[:controller_class].send(options[:action])
      view.should be_an_instance_of(Jooxe::View)
      
      #puts "view == " + view.inspect
      
      view.instance.should be_nil
      view.redirect_to.should eq('/users')
    end
    
    it "should update an instance when calling update with action in path info" do
      @env["PATH_INFO"] = "/users/2/update"
      options = @router.route(@env)
      options[:model_class_name].should eq('User')
      options[:table_name].should eq('users')
      options[:controller_class].should be_an_instance_of(UsersController)
      options[:action].should eq('update')
      
      #puts "model == " + options[:model_class].inspect
      
      view = options[:controller_class].send(options[:action])
      view.should be_an_instance_of(Jooxe::View)
      
      #puts "view == " + view.inspect
      
      view.instance.should be_an_instance_of(User)
      view.instance.id.should eq(2)
      view.instance.mail.should eq('johnboy@thewaltons.com')
    end
    
    it "should update an instance when calling update with put verb" do
      @env["PATH_INFO"] = "/users/2"
      @env["REQUEST_METHOD"] = "PUT"
      options = @router.route(@env)
      options[:model_class_name].should eq('User')
      options[:table_name].should eq('users')
      options[:controller_class].should be_an_instance_of(UsersController)
      options[:action].should eq('update')
      
      #puts "model == " + options[:model_class].inspect
      
      view = options[:controller_class].send(options[:action])
      view.should be_an_instance_of(Jooxe::View)
      
      #puts "view == " + view.inspect
      
      view.instance.should be_an_instance_of(User)
      view.instance.mail.should eq('sue.ellen@thewaltons.com')
    end
 
  end
  
end
