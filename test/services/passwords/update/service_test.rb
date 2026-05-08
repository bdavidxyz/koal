require "test_helper"

class Passwords::Update::ServiceTest < ActiveSupport::TestCase
  setup do
    @user = users(:jane)
  end

  test "successfully updates password with valid password_challenge" do
    result = Passwords::Update::Service.call(
      user: @user,
      password: "NewPassword123456",
      password_confirmation: "NewPassword123456",
      password_challenge: "Secret1*3*5*"
    )

    assert result.success?, "Service failed with errors: #{result.data[:user].errors.full_messages.join(', ')}"
    assert_instance_of User, result.data[:user]
    assert @user.reload.authenticate("NewPassword123456")
  end

  test "fails with invalid password_challenge" do
    result = Passwords::Update::Service.call(
      user: @user,
      password: "NewPassword123456",
      password_confirmation: "NewPassword123456",
      password_challenge: "WrongPassword"
    )

    assert result.failure?
    assert_instance_of User, result.data[:user]
    assert result.data[:user].errors[:password_challenge].any?
  end

  test "fails with password confirmation mismatch" do
    result = Passwords::Update::Service.call(
      user: @user,
      password: "NewPassword123456",
      password_confirmation: "DifferentPassword123",
      password_challenge: "Secret1*3*5*"
    )

    assert result.failure?
    assert_instance_of User, result.data[:user]
    assert result.data[:user].errors[:password_confirmation].any?
  end

  test "fails with too short password" do
    result = Passwords::Update::Service.call(
      user: @user,
      password: "short",
      password_confirmation: "short",
      password_challenge: "Secret1*3*5*"
    )

    assert result.failure?
    assert_instance_of User, result.data[:user]
    assert result.data[:user].errors[:password].any?
  end
end
