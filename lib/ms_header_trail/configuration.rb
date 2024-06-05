# frozen_string_literal: true

module MsHeaderTrail
  # Class responsible for configure the process
  class Configuration
    # Key to identify the data included into process, default: msht-
    attr_accessor :prefix_keyname

    # If the header should be returned into rack response, default: false
    attr_accessor :rack_header_response

    def initialize
      @prefix_keyname = "msht-"
    end

    def to_store(key)
      "#{prefix_keyname}#{key}"
    end

    def from_store(key)
      key.to_s.gsub(prefix_keyname, "").to_sym
    end

    def http_request_prefix_keyname
      prefix_keyname.gsub("-", "_").upcase
    end

    def http_response_prefix_keyname
      prefix_keyname.to_s.split(/[-_]/).map(&:capitalize).join("-")
    end
  end
end
