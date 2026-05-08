require "test_helper"

class Identity::PasswordResets::Create::ServiceTest < ActiveSupport::TestCase
  include Servus::Support::Errors
  test "successfully sends password reset email for verified user" do
    user = users(:jane)
    user.update!(verified: true)

    assert_enqueued_emails 1 do
      result = Identity::PasswordResets::Create::Service.call(
        email: user.email
      )

      assert result.success?
      assert_equal user, result.data[:user]
    end
  end

  test "fails for unverified user" do
    user = users(:jane)
    user.update!(verified: false)

    assert_no_enqueued_emails do
      result = Identity::PasswordResets::Create::Service.call(
        email: user.email
      )

      assert result.failure?
      assert_equal ValidationError, result.error.class
    end
  end

  test "fails for non-existent email" do
    assert_no_enqueued_emails do
      result = Identity::PasswordResets::Create::Service.call(
        email: "nonexistent@example.com"
      )

      assert result.failure?
      assert_equal ValidationError, result.error.class
    end
  end
end
