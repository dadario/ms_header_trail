# frozen_string_literal: true

require_relative "ms_header_trail/version"

# Rack autoload module
module Rack
  autoload :MsHeaderTrail, "rack/ms_header_trail"
end

# This service include the collected information passed into method `collect`
# to be retrieved later where will be used. In rack process, faraday connection
# or Bunny process
module MsHeaderTrail
  autoload :Configuration, "ms_header_trail/configuration"

  class << self
    # Public: Collect the given parameters, which is set by user on
    # start the capture process or during the Rack middleware
    def collect(attributes)
      attributes.each_pair do |key, value|
        set(configuration.to_store(key), value.to_s)
      end
    end

    # Public: Retrive the stored parameters, which was set by user
    # during the Rack middleware, faraday connection or manually
    def retrieve
      Thread.current
            .keys
            .select { |key| key.start_with?(configuration.prefix_keyname) }
            .each_with_object({}) { |key, memo| memo[configuration.from_store(key)] = get(key) }
    end

    # Public: Execute a block code after data collected
    def with(attributes)
      collect(attributes)
      yield
    end

    # Public: Retrieve the given key
    def get(key)
      Thread.current[key]
    end

    # Public: Set the given key to the given value
    def set(key, value)
      Thread.current[key] = value
    end

    def configuration
      @configuration ||= Configuration.new
    end

    # Public: Configure the process.
    #
    # Examples
    #
    #   MsHeaderTrail.configure do |config|
    #     config.prefix_keyname = 'msht-'
    #   end
    def configure
      yield configuration
    end
  end
end
