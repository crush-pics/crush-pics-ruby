# frozen_string_literal: true

module CrushPics
  class Client
    attr_reader :api_token, :response

    def initialize(api_token:)
      @api_token = api_token
    end

    def compress_async(io: nil, url: nil, level: nil, type: nil)
      attrs = build_image_attributes(io: io, url: url, level: level, type: type)

      http_post('original_images', attrs)
      return yield(response) if block_given?

      response
    end

    def compress_sync(io: nil, url: nil, level: nil, type: nil)
      attrs = build_image_attributes(io: io, url: url, level: level, type: type)

      http_post('compress', attrs)
      return yield(response) if block_given?

      response
    end

    def list_images(page = nil)
      path = 'images'
      path = "images/?page=#{ page }" if page
      http_get(path)
      return yield(response) if block_given?

      response
    end

    def fetch_image(id)
      http_get("original_images/#{ id }")
      return yield(response) if block_given?

      response
    end

    def dashboard
      http_get('dashboard')
      return yield(response) if block_given?

      response
    end

    def http_get(path, headers = {})
      uri = URI(base_url + '/' + path)
      request = Net::HTTP::Get.new(uri)
      headers.transform_keys! { |key| key.to_s.tr('_', '-') }
      default_headers.merge(headers).each { |k, v| request[k] = v }

      perform_request(request, uri)
    end

    def http_post(path, payload, headers = {})
      uri = URI(base_url + '/' + path)
      request = Net::HTTP::Post.new(uri)
      headers.transform_keys! { |key| key.to_s.tr('_', '-') }
      default_headers.merge(headers).each { |k, v| request[k] = v }
      request.set_form_data(payload)

      perform_request(request, uri)
    end

    def http_patch(path, payload, headers = {})
      uri = URI(base_url + '/' + path)
      request = Net::HTTP::Patch.new(uri)
      headers.transform_keys! { |key| key.to_s.tr('_', '-') }
      default_headers.merge(headers).each { |k, v| request[k] = v }
      request.set_form_data(payload)

      perform_request(request, uri)
    end

    def http_delete(path, headers = {})
      uri = URI(base_url + '/' + path)
      request = Net::HTTP::Delete.new(uri)
      headers.transform_keys! { |key| key.to_s.tr('_', '-') }
      default_headers.merge(headers).each { |k, v| request[k] = v }

      perform_request(request, uri)
    end

    private

    def check_response!
      return if response.success? || response.validation_error?

      raise(CrushPics::ServerError) if response.server_error?

      raise(CrushPics::UnauthorizedError) if response.unauthorized?

      raise(CrushPics::ClientError, response.http.message) if response.client_error?

      raise(CrushPics::UnknownError)
    end

    def default_headers
      { 'Content-Type' => 'application/json', 'Accept' => 'application/json' }.tap do |h|
        h.store('Authorization', "Bearer #{ api_token }") if api_token
      end
    end

    def build_image_attributes(io: nil, url: nil, level:, type:)
      attrs = { origin: 'api', compression_level: level, compression_type: type }

      if io
        attrs.store(:file, io)
      elsif url
        attrs.store(:image_url, url)
      else
        raise StandardError, 'Specify image IO or URL'
      end

      attrs.reject { |_k, v| v.nil? }
    end

    def base_url
      URI.join(CrushPics.configuration.base_url, CrushPics.configuration.api_version).to_s
    end

    def perform_request(request, uri)
      http = Net::HTTP.new(uri.hostname, uri.port)
      http.use_ssl = true
      http.read_timeout = CrushPics.configuration.read_timeout
      http.set_debug_output(CrushPics.configuration.debug_logger) if CrushPics.configuration.debug_logger
      @response = CrushPics::Response.new(http.request(request))
      check_response!
      @response
    end
  end
end
