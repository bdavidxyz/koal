require "test_helper"

class Registrations::Create::ServiceTest < ActiveSupport::TestCase
  test "successfully registers a new user" do
    cookies = mock_cookies

    assert_difference -> { User.count } => 1, -> { Session.count } => 1 do
      result = Registrations::Create::Service.call(
        attributes: {
          email: "newuser@example.com",
          password: "password123456",
          password_confirmation: "password123456"
        },
        cookies: cookies
      )

      assert result.success?, "Service failed with errors: #{result.data[:user].errors.full_messages.join(', ')}"
      assert_instance_of User, result.data[:user]
      assert_equal "newuser@example.com", result.data[:user].email
      assert_not_nil cookies.signed.permanent[:session_token]
    end
  end

  test "fails with invalid attributes" do
    cookies = mock_cookies

    assert_no_difference [ "User.count", "Session.count" ] do
      result = Registrations::Create::Service.call(
        attributes: {
          email: "invalid-email",
          password: "short",
          password_confirmation: "mismatch"
        },
        cookies: cookies
      )

      assert result.failure?
      assert_instance_of User, result.data[:user]
      assert result.data[:user].errors[:email].any?
    end
  end

  private

  def mock_cookies
    cookies = {}
    def cookies.signed
      self
    end
    def cookies.permanent
      self
    end
    cookies
  end
end
