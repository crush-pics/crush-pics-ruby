# frozen_string_literal: true

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'crush_pics/version'

Gem::Specification.new do |s|
  s.name        = 'crush_pics'
  s.version     = CrushPics::VERSION
  s.date        = '2019-09-26'
  s.summary     = 'Lightweight client for Crush.pics API'
  s.description = 'Lightweight client for Crush.pics API'
  s.authors     = ['Dom Barisic', 'Ilya Shcherbinin']
  s.email       = 'dom@spacesquirrel.co'
  s.files       = Dir['lib/**/*.rb']
  s.homepage    = 'https://github.com/crush-pics/crush-pics-ruby'
  s.license     = 'MIT'
end
