# Load the application
require File.expand_path('../application', __FILE__)

ENV['JOOXE_ROOT'] = File.expand_path(File.dirname(__FILE__) + "/..")

$LOAD_PATH.unshift(ENV['JOOXE_ROOT'])
$LOAD_PATH.unshift(ENV['JOOXE_ROOT'] + "/lib")
