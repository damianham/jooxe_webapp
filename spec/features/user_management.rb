require 'spec_helper'

feature "user management" do
  scenario "creating a new widget" do
    visit root_url
    click_link "New User"

    fill_in "Name", :with => "Fred Blogs"
    click_button "Create User"

    expect(page).to have_text("User was successfully created.")
  end
end