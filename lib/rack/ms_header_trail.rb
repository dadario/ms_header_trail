# frozen_string_literal: true

module Rack

  # Public: Rack middleware that stores the collection data from header in a
  # thread local variable.
  #
  # Examples
  #
  #   use Rack::MsHeaderTrail
  class MsHeaderTrail
    REQUEST_HEADER_PREFIX  = "HTTP_X_"
    RESPONSE_HEADER_PREFIX = "X-"

    def initialize(app, options = nil)
      @app = app
      @options = options
    end

    def call(env)
      ::MsHeaderTrail.with(retrive_from_header(env)) do
        status, headers, body = @app.call(env)

        into_headers(headers) if ::MsHeaderTrail.configuration.rack_header_response

        [status, headers, body]
      end
    end

    private

    def retrive_from_header(env)
      env.keys
         .select { |key| header_key?(key) }
         .each_with_object({}) { |key, memo| memo[local_attr_name(key)] = env[key] }
    end

    def into_headers(headers)
      ::MsHeaderTrail.retrieve.each_pair do |key, value|
        headers[response_attr_name(key)] = value
      end
    end

    def response_attr_name(key)
      "#{response_prefix_name}-#{response_key(key)}"
    end

    def response_key(key)
      key.to_s.split(/[-_]/).map(&:capitalize).join("-")
    end

    def header_key?(key)
      key.to_s.start_with?(request_prefix_name)
    end

    def local_attr_name(key)
      key.to_s.gsub(request_prefix_name, "").downcase
    end

    def response_prefix_name
      "#{RESPONSE_HEADER_PREFIX}#{::MsHeaderTrail.configuration.http_response_prefix_keyname}"
    end

    def request_prefix_name
      "#{REQUEST_HEADER_PREFIX}#{::MsHeaderTrail.configuration.http_request_prefix_keyname}"
    end
  end
end
