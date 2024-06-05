# frozen_string_literal: true

require "ms_header_trail"
require "faraday"

module Faraday
  # Public: Faraday middleware that stores audit data local thread into http header
  # request
  #
  # Examples
  #
  #  Faraday.new(configuration.host) do |builder|
  #    builder.use Faraday::MsHeaderTrail
  #
  class MsHeaderTrail < Faraday::Middleware
    RESPONSE_HEADER_PREFIX = "X-"

    def initialize(app, options = nil)
      super
      @app = app
    end

    def call(env)
      ::MsHeaderTrail.retrieve.each_pair do |key, value|
        set_header(env, key, value)
      end
      @app.call(env)
    end

    private

    def set_header(env, key, value)
      env[:request_headers][header_attr_name(key)] = value
    end

    def header_attr_name(key)
      "#{header_prefix_name}-#{header_key(key)}"
    end

    def header_key(key)
      key.to_s.split(/[-_]/).map(&:capitalize).join("-")
    end

    def header_prefix_name
      "#{RESPONSE_HEADER_PREFIX}#{::MsHeaderTrail.configuration.http_response_prefix_keyname}"
    end
  end
end
