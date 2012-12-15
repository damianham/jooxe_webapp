
Given /^I visit the homepage$/ do
  visit('/')
end

Then /^I should see welcome/ do
  page.should have_css('div#welcome')
  page.should have_content('Your Jooxe is flowing Jimmy!')
end
