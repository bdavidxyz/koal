require "test_helper"

class RegistrationsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get sign_up_url
    assert_response :success
  end

  test "should sign up" do
    assert_difference("User.count") do
      post sign_up_url, params: { email: "lazaronixon@hey.com", password: "Secret1*3*5*", password_confirmation: "Secret1*3*5*" }
    end

    assert_redirected_to myaccount_email_path
  end

  test "should render new when validation fails" do
    assert_no_difference("User.count") do
      post sign_up_url, params: { email: "invalid-email", password: "short", password_confirmation: "short" }
    end

    assert_response :unprocessable_content
    assert_template :new
  end
end
