require "test_helper"
require "ostruct"

class JobsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user_with_superadmin = users(:jane)     # has superadmin role
    @user_without_superadmin = users(:alicia) # only has member role
  end

  test "non-superadmin user cannot access jobs route" do
    sign_in_as(@user_without_superadmin)

    # Test that non-superadmin user gets 404 when trying to access jobs
    get "/jobs"
    assert_response :not_found
  end

  test "superadmin user can really access jobs route" do
    sign_in_as(@user_with_superadmin)

    # Test that non-superadmin user gets 404 when trying to access jobs
    get "/jobs"
    assert_response :success
  end

  test "unauthenticated user cannot access jobs route" do
    # Test that unauthenticated user gets 404 when trying to access jobs
    get "/jobs"
    assert_response :not_found
  end
end