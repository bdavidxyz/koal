require "test_helper"

class Registrations::New::ServiceTest < ActiveSupport::TestCase
  test "successfully returns a new user" do
    result = Registrations::New::Service.call

    assert result.success?
    assert_instance_of User, result.data[:user]
    assert result.data[:user].new_record?
  end
end
