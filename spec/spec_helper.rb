$LOAD_PATH.unshift(File.join(__dir__,'lib'))

require 'rspec'
require 'simplecov'
require 'rack/test'
require 'capybara/rspec'
require_relative '../app'

App.set :environment, :test
Capybara.app = App

RSpec.configure do |config|
  config.include Rack::Test::Methods
end

SimpleCov.start
