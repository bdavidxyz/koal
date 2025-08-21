require "test_helper"

class ChroniclesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get chronicles_path
    assert_response :success
  end

  test "should display published chronicles on index" do
    get chronicles_path
    assert_response :success
    assert_not_nil assigns(:chronicles)
    assert_select "h1", "Chronicles"
  end

  test "should search chronicles" do
    get chronicles_path(q: "web development")
    assert_response :success
    assert_not_nil assigns(:chronicles)
  end

  test "should sort chronicles by title" do
    get chronicles_path(sort: "title", direction: "asc")
    assert_response :success
    assert_not_nil assigns(:chronicles)
  end

  test "should sort chronicles by published_at" do
    get chronicles_path(sort: "published_at", direction: "desc")
    assert_response :success
    assert_not_nil assigns(:chronicles)
  end

  test "should show chronicle" do
    get chronicle_path(chronicles(:first_chronicle).slug)
    assert_response :success
    assert_not_nil assigns(:chronicle)
    assert_equal chronicles(:first_chronicle), assigns(:chronicle)
  end

  test "should not show unpublished chronicle" do
    # Create an unpublished chronicle (published_at in the future)
    unpublished = Chronicle.create!(
      title: "Unpublished Chronicle",
      kontent: "This chronicle is not yet published",
      slug: "unpublished-chronicle",
      chapo: "An unpublished chronicle",
      published_at: 1.day.from_now
    )

    assert_raises(ActionController::RoutingError) do
      get chronicle_path(unpublished.slug)
    end
  end

  test "should return 404 for non-existent chronicle" do
    assert_raises(ActionController::RoutingError) do
      get chronicle_path("non-existent-slug")
    end
  end
end
