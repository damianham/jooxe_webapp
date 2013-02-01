require 'spec_helper'

#  uses the rails method post which is not defined in capybara
#
#describe "user API", :type => :controller do
#  it "allows API clients to create users" do
#    post '/users', :user => { :given_name => "Jack Daniels" }, :format => "json"
#
#    expect(response.status).to eq(201) # "Created"
#  end
#end