# frozen_string_literal: true

module CrushPics
  class Configuration
    DEFAULT_API_VERSION = 'v1'
    DEFAULT_BASE_URL = 'https://api.crush.pics'
    DEFAULT_READ_TIMEOUT = 30

    attr_writer :api_version, :base_url, :read_timeout
    attr_accessor :debug_logger

    def api_version
      @api_version || DEFAULT_API_VERSION
    end

    def base_url
      @base_url || DEFAULT_BASE_URL
    end

    def read_timeout
      @read_timeout || DEFAULT_READ_TIMEOUT
    end
  end
end
