$LOAD_PATH.unshift(File.join(__dir__,'lib'))

require 'rspec'
require 'simplecov'
require 'rack/test'
require 'capybara/rspec'
require_relative '../app'

RSpec.configure do |config|
  config.include Rack::Test::Methods

  Capybara.app = App
end

SimpleCov.start
