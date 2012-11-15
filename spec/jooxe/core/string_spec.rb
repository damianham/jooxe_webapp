require 'spec_helper'

describe String do
  
  # check camel_case
  it "should convert to camel case" do
    orig = "underscored_string"
    orig.camel_case.should eq("UnderscoredString")
  end
  
  # check is_plural?
  it "should detect singular string as false" do
    orig = "post"
    orig.is_plural?.should eq(false)
  end
  
  it "should detect plural string as true" do
    orig = "posts"
    orig.is_plural?.should eq(true)
  end
  
  it "should detect plural irregular string as true" do
    orig = "people"
    orig.is_plural?.should eq(true)
  end

  # check to_model_name  
  it "should convert plural without underscores to singular model name" do
    orig = "posts"
    orig.to_model_name.should eq("Post")
  end
  
  it "should convert without underscores to singular model name" do
    orig = "post"
    orig.to_model_name.should eq("Post")
  end
  
  it "should convert plural with underscores to singular model name" do
    orig = "user_post"
    orig.to_model_name.should eq("UserPost")
  end
  
  it "should convert without underscores to singular model name" do
    orig = "user_posts"
    orig.to_model_name.should eq("UserPost")
  end
  
  # check to_controller_name
   it "should convert plural without underscores to controller name" do
    orig = "posts"
    orig.to_controller_name.should eq("PostsController")
  end
  
  it "should convert without underscores to controller name" do
    orig = "post"
    orig.to_controller_name.should eq("PostsController")
  end
  
  it "should convert plural with underscores to controller name" do
    orig = "user_post"
    orig.to_controller_name.should eq("UserPostsController")
  end
  
  it "should convert without underscores to controller name" do
    orig = "user_posts"
    orig.to_controller_name.should eq("UserPostsController")
  end
  
end

