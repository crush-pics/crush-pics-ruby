# frozen_string_literal: true

module CrushPics
  class CompressOptions
    VALID_STYLE_ATTRIBUTES = %w[width style height].freeze

    attr_reader :io, :url, :level, :type, :resize

    def initialize(io: nil, url: nil, level:, type:, resize: nil)
      @io = io
      @url = url
      @level = level
      @type = type
      @resize = resize
    end

    def to_h
      attrs = { origin: 'api', compression_level: level, compression_type: type, resize: resize, file: io }
      if url
        attrs.delete(:file)
        attrs.store(:image_url, url)
      end
      attrs.reject! { |_k, v| v.nil? || v.empty? }
      validate!
      attrs
    end

    private

    def validate!
      raise(MissingImageSourceError, 'specify image IO or URL') if io.nil? && url.nil?

      return unless resize

      raise(InvalidResizeValueError, '"resize" has to be an Array') unless resize.is_a?(Array)

      raise(InvalidResizeValueError, 'style object has to have "width", "height" and "style" attributes') unless valid_resize_option?
    end

    def valid_resize_option?
      resize.all? do |style|
        style.is_a?(Hash) && style.keys.map(&:to_s).difference(VALID_STYLE_ATTRIBUTES).empty?
      end
    end
  end
end
