# frozen_string_literal: true

module CrushPics
  class ServerError < StandardError; end
  class ClientError < StandardError; end
  class UnknownError < StandardError; end
  class UnauthorizedError < StandardError; end
end
