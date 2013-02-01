
Given /^I visit the users index page$/  do
  visit('/users')
end

Given /^I visit the page for user (.*)$/  do |id|
  visit("/users/#{id}")
end

Given /I visit the new user page/ do
  visit "/users/new"
end

Given /^the following users:$/ do |users|
  # remove existing users
  Jooxe::User.all.each do |o|
    o.delete
  end
  users.hashes.each do |hash|
    Jooxe::User.create(hash)
  end
  step %{there should be #{users.hashes.length} users}
end

When /^I delete the (\d+)(?:st|nd|rd|th) user$/ do |pos|
  visit users_url
  within("table tr:nth-child(#{pos.to_i+1})") do
    click_link "Destroy"
  end
end

When /^I delete the 4th user and deal with the expected error$/ do
  begin
    step %{I delete the 4th user}
    raise "This should have raised an error"
  rescue => expected
  end
end

When /^I fill in "(.*?)" with "(.*?)"$/ do |element, text|
  fill_in(element, :with => text)
end

When /^I press "(.*?)"$/ do |button|
  click(button)
end

Then /^there should be (\d+) users$/ do |count|
  # table is a Cucumber::Ast::Table
  a = Jooxe::User.all
  a.size.should eq(count.to_i)
end 

Then /^I should see the following users:$/ do |expected_users_table|
  expected_users_table.map_headers!(/name/ => 'Name', /colour/ => 'Colour')
  #expected_users_table.diff!(tableish('table tr', 'td,th'))
  rows = find("table#selector").all('tr')
  table = rows.map { |r| r.all('th,td').map { |c| c.text.strip } }
  expected_users_table.diff!(table)
end

Then /^I should see the following users in a definition list:$/ do |expected_users_table|
  expected_users_table.diff!(tableish('dl#user_dl dt', lambda{|dt| [dt, dt.next.next]}))
end

Then /^I should see the following users in an ordered list:$/ do |expected_users_table|
  expected_users_table.diff!(tableish('ol#user_ol li', lambda{|li| [li]}))
end