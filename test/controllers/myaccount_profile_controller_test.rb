require "test_helper"

class MyaccountProfileControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = sign_in_as(users(:jane))
  end

  test "should get profile" do
    get myaccount_profile_url
    assert_response :success
  end
end
