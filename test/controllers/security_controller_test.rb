require "test_helper"

class SecurityControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:jane)
  end

  test "should detect bot and return ok when honeypot is checked" do
    # Test that the find_bot method is triggered when hp=1 is submitted
    # This should return :ok (200) status and prevent normal sign-in flow
    post sign_in_url, params: {
      email: @user.email,
      password: "Secret1*3*5*",
      hp: "1"
    }

    # The find_bot method should return head :ok when hp == "1"
    assert_response :ok

    # Verify that normal sign-in redirect doesn't happen
    # (no redirect means the before_action stopped execution)
    assert_not flash[:notice]
    assert_not flash[:alert]
  end

  test "should not detect bot when honeypot is not checked" do
    # Test that normal sign-in works when hp is not set or not "1"
    post sign_in_url, params: {
      email: @user.email,
      password: "Secret1*3*5*"
    }

    # Should proceed with normal sign-in and redirect
    assert_redirected_to myaccount_path
    assert_equal "Signed in successfully", flash[:notice]
  end

  test "should not detect bot when honeypot is set to different value" do
    # Test that normal sign-in works when hp is set but not to "1"
    post sign_in_url, params: {
      email: @user.email,
      password: "Secret1*3*5*",
      hp: "0"
    }

    # Should proceed with normal sign-in and redirect
    assert_redirected_to myaccount_path
    assert_equal "Signed in successfully", flash[:notice]
  end

  test "should detect bot with wrong credentials and honeypot checked" do
    # Test that find_bot is triggered even with wrong credentials
    post sign_in_url, params: {
      email: @user.email,
      password: "WrongPassword",
      hp: "1"
    }

    # The find_bot method should return head :ok when hp == "1"
    # This happens before authentication is checked
    assert_response :ok

    # Should not show authentication error since find_bot stops execution
    assert_not flash[:alert]
  end
end
