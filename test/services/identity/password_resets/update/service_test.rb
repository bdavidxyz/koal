require "test_helper"

class Identity::PasswordResets::Update::ServiceTest < ActiveSupport::TestCase
  include Servus::Support::Errors
  test "successfully updates password with valid token" do
    user = users(:jane)
    token = user.generate_token_for(:password_reset)
    new_password = "newpassword123456"

    result = Identity::PasswordResets::Update::Service.call(
      sid: token,
      password: new_password,
      password_confirmation: new_password
    )

    assert result.success?
    assert_equal user, result.data[:user]
    assert user.reload.authenticate(new_password)
  end

  test "fails with mismatched password confirmation" do
    user = users(:jane)
    token = user.generate_token_for(:password_reset)

    result = Identity::PasswordResets::Update::Service.call(
      sid: token,
      password: "newpassword123456",
      password_confirmation: "differentpassword"
    )

    assert result.failure?
    assert_equal ValidationError, result.error.class
    assert_not_nil result.data[:user]
  end

  test "fails with invalid token" do
    result = Identity::PasswordResets::Update::Service.call(
      sid: "invalid_token",
      password: "newpassword123456",
      password_confirmation: "newpassword123456"
    )

    assert result.failure?
    assert_equal NotFoundError, result.error.class
  end

  test "fails with too short password" do
    user = users(:jane)
    token = user.generate_token_for(:password_reset)

    result = Identity::PasswordResets::Update::Service.call(
      sid: token,
      password: "short",
      password_confirmation: "short"
    )

    assert result.failure?
    assert_equal ValidationError, result.error.class
    assert_not_nil result.data[:user]
  end
end
