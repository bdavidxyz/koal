require "test_helper"

class UnauthorizedControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user_with_superadmin = users(:jane)   # has superadmin role
    @user_without_superadmin = users(:alicia) # only has member role
  end

  test "shows different authorization behavior for different actions" do
    sign_in_as(@user_without_superadmin)

    # Test the index action
    get myaccount_chronicle_list_path
    assert_response :redirect
    assert_redirected_to root_path

    # Test the show action
    get myaccount_chronicle_show_path("some-slug")
    assert_response :redirect
    assert_redirected_to root_path

    # Test the create action
    post myaccount_chronicle_create_path, params: { chronicle: { title: "Test" } }
    assert_response :redirect
    assert_redirected_to root_path
  end
end
