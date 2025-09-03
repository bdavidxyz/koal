require "test_helper"

class UnauthorizedControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user_with_superadmin = users(:jane)   # has superadmin role
    @user_without_superadmin = users(:alicia) # only has member role
  end

  test "shows different authorization behavior for different actions" do
    sign_in_as(@user_without_superadmin)

    # Test the index action - should return 404 for unauthorized access
    get myaccount_blogpost_list_path
    assert_response :not_found

    # Test the show action - should return 404 for unauthorized access
    get myaccount_blogpost_show_path("some-slug")
    assert_response :not_found

    # Test the create action - should return 404 for unauthorized access
    post myaccount_blogpost_create_path, params: { blogpost: { title: "Test" } }
    assert_response :not_found

    # Test that superadmin user can access these actions
    sign_in_as(@user_with_superadmin)

    # Index should work for superadmin
    get myaccount_blogpost_list_path
    assert_response :success

    # Create should work for superadmin (but may redirect after successful creation)
    post myaccount_blogpost_create_path, params: { blogpost: { title: "Test Post", slug: "test-post", kontent: "Content" } }
    assert_response :redirect # Should redirect after successful creation
  end
end
