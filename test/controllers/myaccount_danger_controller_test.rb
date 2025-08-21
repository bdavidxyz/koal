require "test_helper"

class MyaccountDangerControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = sign_in_as(users(:jane))
  end

  test "should get danger" do
    get myaccount_danger_url
    assert_response :success
  end

  test "should destroy account" do
    # Store the user ID before deletion
    user_id = @user.id

    # Check that the user exists before deletion
    assert User.exists?(user_id)

    # Perform the account deletion
    assert_difference("User.count", -1) do
      delete myaccount_destroy_url
    end

    # Check that we were redirected to the root path
    assert_redirected_to root_path

    # Check that the flash notice is set
    assert_equal "Your account has been deleted.", flash[:notice]

    # Check that the user no longer exists
    assert_not User.exists?(user_id)
  end
end
