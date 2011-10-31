ENV['RAILS_ENV'] ||= 'test'

require File.expand_path("../support/test_village/config/environment", __FILE__)
require 'rspec/rails'
require 'capybara/rspec'
require 'delorean'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
# Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  config.mock_with :rspec
  config.include Delorean
end
