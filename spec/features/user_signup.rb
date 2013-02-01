require 'spec_helper'
require 'capybara' 
require 'capybara/dsl'
require 'capybara/rspec'
require 'capybara/cucumber'

Capybara.app = JooxeApplication.new
Capybara.run_server = false
World(Capybara) 

# capybara with rspec


feature "Signing up" do
  background do
    Jooxe::User.create(:mail => 'user@example.com', :password => 'caplin')
  end

  scenario "Signing in with correct credentials" do
    within("#session") do
      fill_in 'Login', :with => 'user@example.com'
      fill_in 'Password', :with => 'caplin'
    end
    click_link 'Sign in'
  end

  given(:other_user) { Jooxe::User.create(:mail => 'other@example.com', :password => 'rous') }

  scenario "Signing in as another user" do
    within("#session") do
      fill_in 'Login', :with => other_user.email
      fill_in 'Password', :with => other_user.password
    end
    click_link 'Sign in'
  end
end
