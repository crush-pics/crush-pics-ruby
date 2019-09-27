# frozen_string_literal: true

require 'json'
require 'net/http'

require 'crush_pics/exceptions'
require 'crush_pics/configuration'
require 'crush_pics/client'
require 'crush_pics/response'

module CrushPics
  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield(configuration)
  end
end
