require "test_helper"

class BlogpostsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get blogposts_path
    assert_response :success
  end

  test "should display published blogposts on index" do
    get blogposts_path
    assert_response :success
    assert_not_nil assigns(:blogposts)
    assert_select "h1", "Our Blog"
  end

  test "should search blogposts" do
    get blogposts_path(q: "web development")
    assert_response :success
    assert_not_nil assigns(:blogposts)
  end

  test "should sort blogposts by title" do
    get blogposts_path(sort: "title", direction: "asc")
    assert_response :success
    assert_not_nil assigns(:blogposts)
  end

  test "should sort blogposts by published_at" do
    get blogposts_path(sort: "published_at", direction: "desc")
    assert_response :success
    assert_not_nil assigns(:blogposts)
  end

  test "should show blogpost" do
    get blogpost_path(blogposts(:first_blogpost).slug)
    assert_response :success
    assert_not_nil assigns(:blogpost)
    assert_equal blogposts(:first_blogpost), assigns(:blogpost)
  end

  test "should not show unpublished blogpost" do
    # Create an unpublished blogpost (published_at in the future)
    unpublished = Blogpost.create!(
      title: "Unpublished Blogpost",
      kontent: "This blogpost is not yet published",
      slug: "unpublished-blogpost",
      chapo: "An unpublished blogpost",
      published_at: 1.day.from_now
    )

    get blogpost_path(unpublished.slug)
    assert_response :not_found
  end

  test "should return 404 for non-existent blogpost" do
    get blogpost_path("non-existent-slug")
    assert_response :not_found
  end
end
