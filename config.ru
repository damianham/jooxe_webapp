# config.ru
require 'rack'
require 'rack/contrib'

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.dirname(__FILE__) + "/lib")
$LOAD_PATH.unshift(File.dirname(__FILE__) + "/app/models")
$LOAD_PATH.unshift(File.dirname(__FILE__) + "/app/controllers")

require 'jooxe'

# gzip your responses.
#use Rack::Deflater

#use Rack::Static, :urls => ["css", "/images", "js", "html", 'ico'], :root => "public"

# serve all static files
 #use ActionDispatch::Static
use Jooxe::Static, :urls => [""], :root => "public", :header_rules => [
             # Cache all static files in public caches (e.g. Rack::Cache)
             #  as well as in the browser
             [:all, {'Cache-Control' => 'public, max-age=31536000'}],
  
             # Provide web fonts with cross-origin access-control-headers
             #  Firefox requires this when serving assets using a Content Delivery Network
             [:fonts, {'Access-Control-Allow-Origin' => '*'}]
           ]

use Rack::Lock
#use #<ActiveSupport::Cache::Strategy::LocalCache::Middleware:0x000000029a0838>
use Rack::Runtime

# Override REQUEST_METHOD with _method post params for HTML forms.
use Rack::MethodOverride
use Jooxe::RequestId
#use Rails::Rack::Logger

# Drop the body of the response on HEAD requests.
use Rack::Head                          #use ActionDispatch::Head

#use ActionDispatch::ShowExceptions
#use ActionDispatch::DebugExceptions
#use ActionDispatch::RemoteIp
use Rack::Reloader                      #use ActionDispatch::Reloader
#use ActionDispatch::Callbacks
#use ActiveRecord::ConnectionAdapters::ConnectionManagement
#use ActiveRecord::QueryCache
#use ActionDispatch::Cookies

# provide session management.
#use Rack::Session::CookieStore           #use ActionDispatch::Session::CookieStore
# or Rack::Session::Memcache

#use ActionDispatch::Flash
#use ActionDispatch::ParamsParser

# enables conditional GET using If-None-Match and If-Modified-Since.
use Rack::ConditionalGet

# Automatically sets the ETag header on all String bodies.
use Rack::ETag

#Adds JSON-P support by stripping out the callback param and padding the response with the appropriate callback format.
#Rack::JSONP

#use ActionDispatch::BestStandardsSupport



# implements HTTP Basic Authentication.
#Rack::Auth::Basic

# Detects the client locale using the Accept-Language request header and sets a rack.locale variable in the environment.
#use Rack::Locale 

#use Rack::NestedParams  # parses form params with subscripts (e.g., * “post[title]=Hello”) into a nested/recursive Hash structure (based on Rails’ implementation).

# Enables X-Sendfile support for bodies that can be served from file.
#use Rack::Sendfile 
 
# Modifies the response headers to facilitiate client and proxy caching for static files that minimizes http requests and improves overall load times for second time visitors.
#use Rack::StaticCache, :urls => ["/images", "/css", "/js", "/documents*"], :root => "public" 

# Implements DSL for pure before/after filter like Middlewares.
#use Rack::Callbacks

# Adds CSSHTTPRequest support by encoding responses as CSS for cross-site AJAX-style data loading
#use Rack::CSSHTTPRequest 

# Helps protect against DoS attacks.
# use Rack::Deflect 

# Caches responses to requests without query strings to Disk or a user provider Ruby object. Similar to Rails’ page caching.
#use Rack::ResponseCache 

# Uses ruby-prof to measure request time.
#use Rack::Profiler if ENV['RACK_ENV'] == 'development'

# Rescues exceptions raised from the app and sends a useful email with the exception, stacktrace, and contents of the environment.
# use Rack::MailExceptions


# Adds support for JSON request bodies. The Rack parameter hash is populated by deserializing the JSON data provided in the request body when the Content-Type is application/json.
# gem install json_pure
#use Rack::PostBodyContentTypeParser

# Detects the clients timezone using JavaScript and sets a variable in Rack’s environment with the offset from UTC.
#use Rack::TimeZone

#require 'rack/cache'
#use Rack::Cache

require 'shrimp'     

use Shrimp 

run JooxeApplication.new



