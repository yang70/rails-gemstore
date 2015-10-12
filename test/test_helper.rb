Rails.env = "test"
require File.expand_path("../../config/environment", __FILE__)
require "rails/test_help"
require "minitest/rails"
require "minitest/rails/capybara"

class ActiveSupport::TestCase
  fixtures :all
  # Add more helper methods to be used by all tests here...
end
