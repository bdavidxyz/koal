require "test_helper"

class MyaccountBlogtagsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = sign_in_as(users(:jane))
    @blogtag = blogtags(:first_blogtag)
  end

  test "should get index" do
    get myaccount_blogtag_list_url
    assert_response :success
  end

  test "should get index with sort and direction parameters" do
    get myaccount_blogtag_list_url, params: { sort: "name", direction: "asc", q: "" }
    assert_response :success
  end

  test "should get new" do
    get myaccount_blogtag_new_url
    assert_response :success
  end

  test "should create blogtag" do
    assert_difference("Blogtag.count") do
      post myaccount_blogtag_create_url, params: { blogtag: { name: "Gamma" } }
    end

    assert_redirected_to myaccount_blogtag_list_url
  end

  test "should show blogtag" do
    get myaccount_blogtag_show_url(slug: @blogtag.slug)
    assert_response :success
  end

  test "should get edit" do
    get myaccount_blogtag_edit_url(slug: @blogtag.slug)
    assert_response :success
  end

  test "should update blogtag" do
    put myaccount_blogtag_update_url(slug: @blogtag.slug), params: { blogtag: { name: @blogtag.name, slug: @blogtag.slug } }
    assert_redirected_to myaccount_blogtag_list_url
  end

  test "should destroy blogtag" do
    assert_difference("Blogtag.count", -1) do
      delete myaccount_blogtag_destroy_url(slug: @blogtag.slug)
    end

    assert_redirected_to myaccount_url
  end

  test "should not create blogtag with invalid params" do
    assert_no_difference("Blogtag.count") do
      post myaccount_blogtag_create_url, params: { blogtag: { name: "" } }
    end

    assert_response :unprocessable_content
    assert_template :new
  end

  test "should not update blogtag with invalid params" do
    put myaccount_blogtag_update_url(slug: @blogtag.slug), params: { blogtag: { name: "" } }
    assert_response :unprocessable_content
    assert_template :edit
  end

  test "should not create blogtag with name too short" do
    assert_no_difference("Blogtag.count") do
      post myaccount_blogtag_create_url, params: { blogtag: { name: "X" } }
    end

    assert_response :unprocessable_content
    assert_template :new
  end

  test "should not create blogtag with duplicate name" do
    assert_no_difference("Blogtag.count") do
      post myaccount_blogtag_create_url, params: { blogtag: { name: @blogtag.name } }
    end

    assert_response :unprocessable_content
    assert_template :new
  end

  test "should handle search with query parameter" do
    get myaccount_blogtag_list_url, params: { q: "Alpha" }
    assert_response :success
  end

  test "should return 404 for non-existent blogtag" do
    get myaccount_blogtag_show_url(slug: "non-existent-slug")
    assert_response :not_found
  end
end