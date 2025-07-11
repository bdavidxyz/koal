require "test_helper"

class Identity::EmailsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = sign_in_as(users(:jane))
  end

  test "should get edit" do
    get myaccount_email_path
    assert_response :success
  end

  test "should update email" do
    patch identity_email_url, params: { email: "new_email@hey.com", password_challenge: "Secret1*3*5*" }
    assert_redirected_to myaccount_path
  end


  test "should not update email with wrong password challenge" do
    patch identity_email_path, params: { email: "new_email@hey.com", password_challenge: "SecretWrong1*3" }

    assert_response :unprocessable_entity
    assert_select "li", /Password challenge is invalid/
  end
end
