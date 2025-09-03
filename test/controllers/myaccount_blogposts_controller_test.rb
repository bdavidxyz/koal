require "test_helper"

class MyaccountBlogpostsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = sign_in_as(users(:jane))
    @blogpost = blogposts(:first_blogpost)
    @first_blogtag = blogtags(:first_blogtag)
    @second_blogtag = blogtags(:second_blogtag)
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
      post myaccount_blogpost_create_url, params: { blogpost: { chapo: @blogpost.chapo, kontent: @blogpost.kontent, published_at: @blogpost.published_at, slug: "new_slug", title: @blogpost.title, blogtag_ids: [ @first_blogtag.id, @second_blogtag.id ] } }
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
    put myaccount_blogpost_update_url(slug: @blogpost.slug), params: { blogpost: { chapo: @blogpost.chapo, kontent: @blogpost.kontent, published_at: @blogpost.published_at, slug: @blogpost.slug, title: @blogpost.title, blogtag_ids: [ @first_blogtag.id ] } }
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
      post myaccount_blogpost_create_url, params: { blogpost: { chapo: @blogpost.chapo, kontent: @blogpost.kontent, published_at: @blogpost.published_at, slug: "new_slug", title: "", blogtag_ids: [ @first_blogtag.id ] } }
    end

    assert_response :unprocessable_content
    assert_template :new
  end

  test "should not update blogpost with invalid params" do
    put myaccount_blogpost_update_url(slug: @blogpost.slug), params: { blogpost: { chapo: @blogpost.chapo, kontent: @blogpost.kontent, published_at: @blogpost.published_at, slug: @blogpost.slug, title: "", blogtag_ids: [ @first_blogtag.id ] } }
    assert_response :unprocessable_content
    assert_template :edit
  end

  test "should create blogpost with blogtag associations" do
    assert_difference("Blogpost.count", 1) do
      assert_difference("BlogtagBlogpost.count", 2) do
        post myaccount_blogpost_create_url, params: { blogpost: { chapo: "Test chapo", kontent: "Test content", published_at: Time.current, slug: "test_slug", title: "Test Title", blogtag_ids: [ @first_blogtag.id, @second_blogtag.id ] } }
      end
    end

    blogpost = Blogpost.find_by(slug: "test_slug")
    assert_equal 2, blogpost.blogtags.count
    assert_includes blogpost.blogtags, @first_blogtag
    assert_includes blogpost.blogtags, @second_blogtag
    assert_redirected_to myaccount_blogpost_list_url
  end

  test "should update blogpost and replace blogtag associations" do
    # @blogpost (first_blogpost) already has 2 associations from fixtures: Alpha and Beta
    initial_count = BlogtagBlogpost.count
    initial_blogpost_associations = @blogpost.blogtags.count

    # Update with just one blogtag - should replace existing ones
    put myaccount_blogpost_update_url(slug: @blogpost.slug), params: { blogpost: { chapo: @blogpost.chapo, kontent: @blogpost.kontent, published_at: @blogpost.published_at, slug: @blogpost.slug, title: @blogpost.title, blogtag_ids: [ @second_blogtag.id ] } }

    @blogpost.reload
    assert_equal 1, @blogpost.blogtags.count
    assert_includes @blogpost.blogtags, @second_blogtag
    assert_not_includes @blogpost.blogtags, @first_blogtag
    # Should decrease by (initial_associations - new_associations)
    assert_equal initial_count - (initial_blogpost_associations - 1), BlogtagBlogpost.count
    assert_redirected_to myaccount_blogpost_list_url
  end

  test "should create blogpost without blogtag associations when no blogtag_ids provided" do
    assert_difference("Blogpost.count") do
      assert_no_difference("BlogtagBlogpost.count") do
        post myaccount_blogpost_create_url, params: { blogpost: { chapo: "Test chapo", kontent: "Test content", published_at: Time.current, slug: "no_tags_slug", title: "No Tags Title" } }
      end
    end

    blogpost = Blogpost.find_by(slug: "no_tags_slug")
    assert_equal 0, blogpost.blogtags.count
    assert_redirected_to myaccount_blogpost_list_url
  end

  test "should update blogpost and remove all blogtag associations when empty blogtag_ids provided" do
    # @blogpost (first_blogpost) already has 2 associations from fixtures: Alpha and Beta
    initial_associations = @blogpost.blogtags.count

    assert_difference("BlogtagBlogpost.count", -initial_associations) do
      put myaccount_blogpost_update_url(slug: @blogpost.slug), params: { blogpost: { chapo: @blogpost.chapo, kontent: @blogpost.kontent, published_at: @blogpost.published_at, slug: @blogpost.slug, title: @blogpost.title, blogtag_ids: [] } }
    end

    @blogpost.reload
    assert_equal 0, @blogpost.blogtags.count
    assert_redirected_to myaccount_blogpost_list_url
  end
end
