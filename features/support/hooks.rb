#Capybara.app_host = "http://google.com"
#Capybara.default_driver = :selenium
Capybara.app = JooxeApplication.new

Before do |scenario|
  # executed before the first step of each scenario
  
end

After do |scenario|
  # executed after the last step of each scenario
end