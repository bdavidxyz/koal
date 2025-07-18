require "test_helper"

class UserMailerTest < ActionMailer::TestCase
  setup do
    @user = users(:jane)
  end

  test "password_reset" do
    mail = UserMailer.with(user: @user).password_reset
    assert_equal "Reset your password", mail.subject
    assert_equal [@user.email], mail.to
  end

  test "email_verification" do
    mail = UserMailer.with(user: @user).email_verification
    assert_equal "Verify your email", mail.subject
    assert_equal [@user.email], mail.to
  end
end
