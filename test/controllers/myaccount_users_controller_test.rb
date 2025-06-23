require "test_helper"

class MyaccountUsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = sign_in_as(users(:jane))
    @other_user = users(:alicia)
  end

  test "should get index" do
    get myaccount_user_list_url
    assert_response :success
  end

  test "should get new" do
    get myaccount_user_new_url
    assert_response :success
  end

  test "should create user" do
    assert_difference("User.count") do
      post myaccount_user_create_url, params: { user: { email: "new@example.com", name: "New User", password: "321Password!!!", slug: "new-user" } }
    end

    assert_redirected_to myaccount_user_list_url
  end

  test "should show user" do
    get myaccount_user_show_url(slug: @other_user.slug)
    assert_response :success
  end

  test "should get edit" do
    get myaccount_user_edit_url(slug: @other_user.slug)
    assert_response :success
  end

  test "should update user" do
    put myaccount_user_update_url(slug: @other_user.slug), params: { user: { email: @other_user.email, name: @other_user.name, slug: @other_user.slug } }
    assert_redirected_to myaccount_user_list_url
  end

  test "should destroy user" do
    assert_difference("User.count", -1) do
      delete myaccount_user_destroy_url(slug: @other_user.slug)
    end

    assert_redirected_to myaccount_url
  end
end
