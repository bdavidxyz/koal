require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:jane)
  end

  test "should get index" do
    sign_in_as @user

    get myaccount_sessions_path
    assert_response :success
  end

  test "should get new" do
    get sign_in_url
    assert_response :success
  end

  test "should sign in" do
    post sign_in_url, params: { email: @user.email, password: "Secret1*3*5*" }
    assert_redirected_to myaccount_path

    get root_url
    assert_response :success
  end

  test "should not sign in with wrong credentials" do
    post sign_in_url, params: { email: @user.email, password: "SecretWrong1*3" }
    assert_redirected_to sign_in_url(email_hint: @user.email)
    assert_equal "That email or password is incorrect", flash[:alert]
  end

  test "should sign out" do
    sign_in_as @user

    delete session_path(@user.sessions.last)

    follow_redirect!
    assert_redirected_to sign_in_url
  end
end
