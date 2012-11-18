# config.ru
require 'rack'
require 'rack/contrib'

require 'environment'

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.dirname(__FILE__) + "/lib")

require 'jooxe'

# serve all static files
use Jooxe::Static, :urls => [""], :root => "public", :header_rules => [
             # Cache all static files in public caches (e.g. Rack::Cache)
             #  as well as in the browser
             [:all, {'Cache-Control' => 'public, max-age=31536000'}],
  
             # Provide web fonts with cross-origin access-control-headers
             #  Firefox requires this when serving assets using a Content Delivery Network
             [:fonts, {'Access-Control-Allow-Origin' => '*'}]
           ]

use Rack::Lock

use Rack::Runtime

# Override REQUEST_METHOD with _method post params for HTML forms.
use Rack::MethodOverride
use Jooxe::RequestId

# Drop the body of the response on HEAD requests.
use Rack::Head        
use Rack::ShowExceptions
use Rack::Reloader          

# enables conditional GET using If-None-Match and If-Modified-Since.
use Rack::ConditionalGet

# Automatically sets the ETag header on all String bodies.
use Rack::ETag


run JooxeApplication.new



