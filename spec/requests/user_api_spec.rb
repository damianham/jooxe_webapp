require 'spec_helper'

describe "user API" do
  it "allows API clients to create users" do
    post '/users', :user => { :given_name => "Jack Daniels" }, :format => "json"

    expect(response.status).to eq(201) # "Created"
  end
end