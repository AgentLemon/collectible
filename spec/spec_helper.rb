$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'simplecov'
require 'collectible'
require 'csv'
# require 'pry'

SimpleCov.start

def load_collection(filename)
  file = File.read(File.expand_path("./fixtures/#{ filename }.csv", File.dirname(__FILE__)))
  CSV.parse(file, headers: true)
end