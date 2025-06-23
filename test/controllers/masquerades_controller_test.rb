require "test_helper"

class MasqueradesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = sign_in_as(users(:jane))
    @other_user = users(:alicia)
  end

  test "should masquerade in development" do
    post user_masquerade_url(user_id: @other_user.id)
    assert_redirected_to myaccount_path

    get myaccount_path
    assert_select ".js-current-email", text: @other_user.email
  end
end
