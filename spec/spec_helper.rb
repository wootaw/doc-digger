require "codeclimate-test-reporter"
CodeClimate::TestReporter.start

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'ap'
require 'pry'
require 'restwoods'

# Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each do |f|
#   m = /(support(\/\w+)*\/\w+)\.rb/.match(f)
#   require m[1] unless m[1].nil?
# end
