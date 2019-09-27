# frozen_string_literal: true

module CrushPics
  class Response
    attr_reader :http

    def initialize(http)
      @http = http
    end

    def parse
      return {} if unauthorized?

      parsed_response
    end

    alias :body :parse

    def unauthorized?
      http.is_a?(Net::HTTPUnauthorized)
    end

    def created?
      http.is_a?(Net::HTTPCreated)
    end

    def validation_error?
      http.is_a?(Net::HTTPUnprocessableEntity)
    end

    def success?
      http.is_a?(Net::HTTPSuccess)
    end

    def client_error?
      http.is_a?(Net::HTTPClientError)
    end

    def server_error?
      http.is_a?(Net::HTTPServerError)
    end

    def validation_error_message
      msgs = parsed_response.fetch('message', {}).map do |k, v|
        msg = v
        msg = msg.join(', ') if msg.is_a?(Array)
        "#{ k }: #{ msg }"
      end
      msgs.join(', ')
    end

    private

    def parsed_response
      @parsed_response ||= JSON.parse(http.body)
    rescue TypeError, JSON::ParserError
      @parsed_response = {}
    end
  end
end
