# frozen_string_literal: true

module CrushPics
  class Webhook
    attr_reader :payload, :event

    def initialize(payload)
      @event = payload.delete('event').inquiry
      @quota_usage = payload.delete('quota_usage')
      @payload = payload
    end

    def original_size_image
      styles['original']
    end

    def image_id
      payload['image_id']
    end

    def webhook_version
      payload['id']
    end

    def styles
      @styles ||= payload['optimized_images'].map do |img|
        [img['style'], img.slice('size', 'link', 'id', 'expire_at', 'status')]
      end.to_h
    end
  end
end
