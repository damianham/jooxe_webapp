
Given /^I visit the homepage$/ do
  visit('/')
end

Then /^I should see welcome/ do
  page.should have_css('div#welcome')
  page.should have_content('Your Jooxe is flowing Jimmy!')
end

Then /^I should see the text (.*)$/ do |text|
  page.should have_content(text)
end

Then /^I should not see the text (.*)$/ do |text|
  page.should_not have_content(text)
end
