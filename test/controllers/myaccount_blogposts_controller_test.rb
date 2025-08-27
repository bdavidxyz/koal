require "test_helper"

class MyaccountBlogpostsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = sign_in_as(users(:jane))
    @blogpost = blogposts(:first_blogpost)
  end

  test "should get index" do
    get myaccount_blogpost_list_url
    assert_response :success
  end

  test "should get index with sort and direction parameters" do
    get myaccount_blogpost_list_url, params: { sort: "title", direction: "asc", q: "" }
    assert_response :success
  end

  test "should get new" do
    get myaccount_blogpost_new_url
    assert_response :success
  end

  test "should create blogpost" do
    assert_difference("Blogpost.count") do
      post myaccount_blogpost_create_url, params: { blogpost: { chapo: @blogpost.chapo, kontent: @blogpost.kontent, published_at: @blogpost.published_at, slug: "new_slug", title: @blogpost.title } }
    end

    assert_redirected_to myaccount_blogpost_list_url
  end

  test "should show blogpost" do
    get myaccount_blogpost_show_url(slug: @blogpost.slug)
    assert_response :success
  end

  test "should get edit" do
    get myaccount_blogpost_edit_url(slug: @blogpost.slug)
    assert_response :success
  end

  test "should update blogpost" do
    put myaccount_blogpost_update_url(slug: @blogpost.slug), params: { blogpost: { chapo: @blogpost.chapo, kontent: @blogpost.kontent, published_at: @blogpost.published_at, slug: @blogpost.slug, title: @blogpost.title } }
    assert_redirected_to myaccount_blogpost_list_url
  end

  test "should destroy blogpost" do
    assert_difference("Blogpost.count", -1) do
      delete myaccount_blogpost_destroy_url(slug: @blogpost.slug)
    end

    assert_redirected_to myaccount_url
  end

  test "should not create blogpost with invalid params" do
    assert_no_difference("Blogpost.count") do
      post myaccount_blogpost_create_url, params: { blogpost: { chapo: @blogpost.chapo, kontent: @blogpost.kontent, published_at: @blogpost.published_at, slug: "new_slug", title: "" } }
    end

    assert_response :unprocessable_content
    assert_template :new
  end

  test "should not update blogpost with invalid params" do
    put myaccount_blogpost_update_url(slug: @blogpost.slug), params: { blogpost: { chapo: @blogpost.chapo, kontent: @blogpost.kontent, published_at: @blogpost.published_at, slug: @blogpost.slug, title: "" } }
    assert_response :unprocessable_content
    assert_template :edit
  end
end
