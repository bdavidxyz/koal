require "simplecov"
SimpleCov.start do
  add_filter "/test/"
  add_filter "/initializers/"
  add_filter "/config/"
  track_files "app/controllers/**/*.rb"
  minimum_coverage_by_file 0
end

ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  def sign_in_as(user)
    post(sign_in_url, params: { email: user.email, password: "Secret1*3*5*" })
    assert_response :redirect
    follow_redirect!
    user
  end
end
