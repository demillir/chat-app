unless ENV['NOCOV']
  require 'simplecov'
  if ENV['CIRCLE_ARTIFACTS']
    dir = File.join("..", "..", "..", ENV['CIRCLE_ARTIFACTS'], "coverage")
    SimpleCov.coverage_dir(dir)
  end
  SimpleCov.minimum_coverage 100
  SimpleCov.start
end

ENV["RAILS_ENV"] = "test"
require File.expand_path("../../config/environment", __FILE__)
require "rails/test_help"
require "minitest/rails"

# To add Capybara feature tests add `gem "minitest-rails-capybara"`
# to the test group in the Gemfile and uncomment the following:
# require "minitest/rails/capybara"

# Uncomment for awesome colorful output
# require "minitest/pride"

require 'active_support/testing/assertions'
include ActiveSupport::Testing::Assertions

# Custom test helper methods
Dir[File.dirname(__FILE__) + "/support/**/*.rb"].each { |file| require file }

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  # fixtures :all
  # Add more helper methods to be used by all tests here...
end
