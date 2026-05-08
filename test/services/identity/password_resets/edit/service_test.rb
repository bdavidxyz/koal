require "test_helper"

class Identity::PasswordResets::Edit::ServiceTest < ActiveSupport::TestCase
  include Servus::Support::Errors
  test "successfully finds user with valid token" do
    user = users(:jane)
    token = user.generate_token_for(:password_reset)

    result = Identity::PasswordResets::Edit::Service.call(
      sid: token
    )

    assert result.success?
    assert_equal user, result.data[:user]
  end

  test "fails with invalid token" do
    result = Identity::PasswordResets::Edit::Service.call(
      sid: "invalid_token"
    )

    assert result.failure?
    assert_equal NotFoundError, result.error.class
  end

  test "fails with expired token" do
    user = users(:jane)
    token = user.generate_token_for(:password_reset)

    travel 21.minutes do
      result = Identity::PasswordResets::Edit::Service.call(
        sid: token
      )

      assert result.failure?
      assert_equal NotFoundError, result.error.class
    end
  end
end
