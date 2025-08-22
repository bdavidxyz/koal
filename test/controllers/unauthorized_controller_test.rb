require "test_helper"

class UnauthorizedControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user_with_superadmin = users(:jane)   # has superadmin role
    @user_without_superadmin = users(:alicia) # only has member role
  end

  test "demonstrates that when_unauthorized is being called through Rabarber authorization" do
    # Sign in as a user without superadmin role
    sign_in_as(@user_without_superadmin)

    # Try to access an action that requires :superadmin role
    # This should trigger Rabarber's authorization check, which calls when_unauthorized
    get myaccount_chronicle_list_path

    # Currently getting redirect because Rabarber::Authorization's when_unauthorized 
    # method redirects back to root_path for HTML requests
    assert_response :redirect
    assert_redirected_to root_path
  end
end
