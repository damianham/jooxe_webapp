module Jooxe

  # originally copied from Rack::Static - https://raw.github.com/rack/rack/master/lib/rack/static.rb
  # 
  # The Jooxe::Static middleware intercepts requests for static files
  # (javascript files, images, stylesheets, etc) based on the url prefixes or
  # route mappings passed in the options, and serves them using a Rack::File
  # object. This allows a Rack stack to serve both static and dynamic content.
  #
  # Examples:
  #
  # Serve all requests beginning with /media from the "media" folder located
  # in the current directory (ie media/*):
  #
  #     use Jooxe::Static, :urls => ["/media"]
  #
  # Serve all requests beginning with /css or /images from the folder "public"
  # in the current directory (ie public/css/* and public/images/*):
  #
  #     use Jooxe::Static, :urls => ["/css", "/images"], :root => "public"
  #
  # Serve all requests to / with "index.html" from the folder "public" in the
  # current directory (ie public/index.html):
  #
  #     use Jooxe::Static, :urls => {"/" => 'index.html'}, :root => 'public'
  #
  # Serve all requests normally from the folder "public" in the current
  # directory but uses index.html as default route for "/"
  #
  #     use Jooxe::Static, :urls => [""], :root => 'public', :index =>
  #     'index.html'
  #
  # Set custom HTTP Headers for based on rules:
  #
  #     use Jooxe::Static, :root => 'public',
  #         :header_rules => [
  #           [rule, {header_field => content, header_field => content}],
  #           [rule, {header_field => content}]
  #         ]
  #
  #  Rules for selecting files:
  #
  #  1) All files
  #     Provide the :all symbol
  #     :all => Matches every file
  #
  #  2) Folders
  #     Provide the folder path as a string
  #     '/folder' or '/folder/subfolder' => Matches files in a certain folder
  #
  #  3) File Extensions
  #     Provide the file extensions as an array
  #     ['css', 'js'] or %w(css js) => Matches files ending in .css or .js
  #
  #  4) Regular Expressions / Regexp
  #     Provide a regular expression
  #     %r{\.(?:css|js)\z} => Matches files ending in .css or .js
  #     /\.(?:eot|ttf|otf|woff|svg)\z/ => Matches files ending in
  #       the most common web font formats (.eot, .ttf, .otf, .woff, .svg)
  #       Note: This Regexp is available as a shortcut, using the :fonts rule
  #
  #  5) Font Shortcut
  #     Provide the :fonts symbol
  #     :fonts => Uses the Regexp rule stated right above to match all common web font endings
  #
  #  Rule Ordering:
  #    Rules are applied in the order that they are provided.
  #    List rather general rules above special ones.
  #
  #  Complete example use case including HTTP header rules:
  #
  #     use Jooxe::Static, :root => 'public',
  #         :header_rules => [
  #           # Cache all static files in public caches (e.g. Rack::Cache)
  #           #  as well as in the browser
  #           [:all, {'Cache-Control' => 'public, max-age=31536000'}],
  #
  #           # Provide web fonts with cross-origin access-control-headers
  #           #  Firefox requires this when serving assets using a Content Delivery Network
  #           [:fonts, {'Access-Control-Allow-Origin' => '*'}]
  #         ]
  #
  class Static

    def initialize(app, options={})
      @app = app
      @urls = options[:urls] || ["/favicon.ico"]
      @index = options[:index]
      @root = options[:root] || Dir.pwd

      # HTTP Headers
      @header_rules = options[:header_rules] || []
      # Allow for legacy :cache_control option while prioritizing global header_rules setting
      #@header_rules.insert(0, [:all, {'Cache-Control' => options[:cache_control]}]) if options[:cache_control]
      @headers = {}

      @file_server = Rack::File.new(@root, @headers)
    end

    def overwrite_file_path(path)
      @urls.kind_of?(Hash) && @urls.key?(path) || @index && path =~ /\/$/
    end

    def route_file(path)
      @urls.kind_of?(Array) && @urls.any? { |url| path.index(url) == 0 }
    end

    def can_serve(path)
      route_file(path) || overwrite_file_path(path)
    end

    def call(env)
      path = env["PATH_INFO"]

      # also check that the file exists or is the favicon
      if can_serve(path) && (File.exist?(File.join(@root,path)) || path == "/favicon.ico")
        env["PATH_INFO"] = (path =~ /\/$/ ? path + @index : @urls[path]) if overwrite_file_path(path)
        @path = env["PATH_INFO"]
        apply_header_rules
        status,headers,content = @file_server.call(env)
        # fix the Cache-Control header if Rack version < 1.5
        cache_control = headers['Cache-Control']
        if cache_control.is_a?(Hash) && cache_control.has_key?('Cache-Control')
          headers['Cache-Control'] = cache_control['Cache-Control']
        end
        [status,headers,content]
      else
        # otherwise continue in the middleware chain
        @app.call(env)
      end
    end

    # Convert HTTP header rules to HTTP headers
    def apply_header_rules
      @header_rules.each do |rule, headers|
        apply_rule(rule, headers)
      end
    end

    def apply_rule(rule, headers)
      case rule
      when :all    # All files
        set_headers(headers)
      when :fonts  # Fonts Shortcut
        set_headers(headers) if @path.match(/\.(?:ttf|otf|eot|woff|svg)\z/)
      when String  # Folder
        path = ::Rack::Utils.unescape(@path)
        set_headers(headers) if (path.start_with?(rule) || path.start_with?('/' + rule))
      when Array   # Extension/Extensions
        extensions = rule.join('|')
        set_headers(headers) if @path.match(/\.(#{extensions})\z/)
      when Regexp  # Flexible Regexp
        set_headers(headers) if @path.match(rule)
      else
      end
    end

    def set_headers(headers)
      headers.each { |field, content| @headers[field] = content }
    end

  end
end