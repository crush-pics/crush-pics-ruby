# frozen_string_literal: true

module CrushPics
  module Plugin
    module KaminariPagination
      def size
        body.dig('pagination', 'count')
      end

      def total_pages
        body.dig('pagination', 'total_pages')
      end

      def total_count
        body.dig('pagination', 'total_count')
      end

      def current_page
        body.dig('pagination', 'current')
      end

      def limit_value
        body.dig('pagination', 'per_page')
      end
    end
  end
end
