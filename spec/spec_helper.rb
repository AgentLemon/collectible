require 'simplecov'
SimpleCov.start

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'collectible'
require 'csv'
# require 'pry'

def load_collection(filename)
  file = File.read(File.expand_path("./fixtures/#{ filename }.csv", File.dirname(__FILE__)))
  CSV.parse(file, headers: true)
end