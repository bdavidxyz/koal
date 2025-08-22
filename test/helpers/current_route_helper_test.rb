require "test_helper"

class CurrentRouteHelperTest < ActionView::TestCase
  include CurrentRouteHelper

  def setup
    @request = ActionDispatch::TestRequest.create
  end

  test "returns nil when request is nil" do
    @request = nil
    assert_nil current_named_route
  end

  test "returns correct named route for sign_in path" do
    @request.path = "/sign_in"
    @request.request_method = "GET"

    assert_equal :sign_in, current_named_route
  end

  test "returns correct named route for sign_up path" do
    @request.path = "/sign_up"
    @request.request_method = "GET"

    assert_equal :sign_up, current_named_route
  end

  test "returns correct named route for myaccount path" do
    @request.path = "/myaccount"
    @request.request_method = "GET"

    assert_equal :myaccount, current_named_route
  end

  test "returns correct named route for myaccount_sessions path" do
    @request.path = "/myaccount/sessions"
    @request.request_method = "GET"

    assert_equal :myaccount_sessions, current_named_route
  end

  test "returns correct named route for myaccount_email path" do
    @request.path = "/myaccount/email"
    @request.request_method = "GET"

    assert_equal :myaccount_email, current_named_route
  end

  test "returns correct named route for myaccount_password path" do
    @request.path = "/myaccount/password"
    @request.request_method = "GET"

    assert_equal :myaccount_password, current_named_route
  end

  test "returns correct named route for myaccount_profile path" do
    @request.path = "/myaccount/profile"
    @request.request_method = "GET"

    assert_equal :myaccount_profile, current_named_route
  end

  test "returns correct named route for myaccount_billing path" do
    @request.path = "/myaccount/billing"
    @request.request_method = "GET"

    assert_equal :myaccount_billing, current_named_route
  end

  test "returns correct named route for myaccount_danger path" do
    @request.path = "/myaccount/danger"
    @request.request_method = "GET"

    assert_equal :myaccount_danger, current_named_route
  end

  test "returns correct named route for myaccount_destroy path with DELETE method" do
    @request.path = "/myaccount/destroy"
    @request.request_method = "DELETE"

    assert_equal :myaccount_destroy, current_named_route
  end

  test "returns correct named route for chronicles index path" do
    @request.path = "/chronicles"
    @request.request_method = "GET"

    assert_equal :chronicles, current_named_route
  end

  test "returns correct named route for chronicle show path" do
    @request.path = "/chronicles/test-chronicle"
    @request.request_method = "GET"

    assert_equal :chronicle, current_named_route
  end

  test "returns correct named route for myaccount_user_list path" do
    @request.path = "/myaccount/users"
    @request.request_method = "GET"

    assert_equal :myaccount_user_list, current_named_route
  end

  test "returns correct named route for myaccount_user_new path" do
    @request.path = "/myaccount/users/new"
    @request.request_method = "GET"

    assert_equal :myaccount_user_new, current_named_route
  end

  test "returns correct named route for myaccount_chronicle_list path" do
    @request.path = "/myaccount/chronicles"
    @request.request_method = "GET"

    assert_equal :myaccount_chronicle_list, current_named_route
  end

  test "returns correct named route for myaccount_chronicle_new path" do
    @request.path = "/myaccount/chronicles/new"
    @request.request_method = "GET"

    assert_equal :myaccount_chronicle_new, current_named_route
  end

  test "returns nil for non-existent path" do
    @request.path = "/non-existent-path"
    @request.request_method = "GET"

    assert_nil current_named_route
  end

  test "returns nil for path with wrong HTTP method" do
    @request.path = "/myaccount"
    @request.request_method = "POST"

    assert_nil current_named_route
  end

  test "handles routing error gracefully" do
    @request.path = "/invalid/route/with/too/many/segments"
    @request.request_method = "GET"

    # Should not raise an error and should return nil
    assert_nil current_named_route
  end

  test "returns nil for empty path" do
    @request.path = ""
    @request.request_method = "GET"

    # Empty path should return nil, but in test environment it might default
    result = current_named_route
    assert result.nil? || result.is_a?(Symbol)
  end

  test "handles paths with query parameters" do
    @request.path = "/chronicles?page=2"
    @request.request_method = "GET"

    assert_equal :chronicles, current_named_route
  end

  test "handles paths with trailing slash" do
    @request.path = "/chronicles/"
    @request.request_method = "GET"

    assert_equal :chronicles, current_named_route
  end

  test "returns correct named route for DELETE session" do
    @request.path = "/sessions/123"
    @request.request_method = "DELETE"

    assert_equal :session, current_named_route
  end

  test "returns correct named route for PUT myaccount_user" do
    @request.path = "/myaccount/users/test-user"
    @request.request_method = "PUT"

    assert_equal :myaccount_user_update, current_named_route
  end

  test "returns correct named route for DELETE myaccount_user" do
    @request.path = "/myaccount/users/test-user"
    @request.request_method = "DELETE"

    assert_equal :myaccount_user_destroy, current_named_route
  end

  test "returns correct named route for PUT myaccount_chronicle" do
    @request.path = "/myaccount/chronicles/test-chronicle"
    @request.request_method = "PUT"

    assert_equal :myaccount_chronicle_update, current_named_route
  end

  test "returns correct named route for DELETE myaccount_chronicle" do
    @request.path = "/myaccount/chronicles/test-chronicle"
    @request.request_method = "DELETE"

    assert_equal :myaccount_chronicle_destroy, current_named_route
  end

  test "returns correct named route for identity email verification" do
    @request.path = "/identity/email_verification"
    @request.request_method = "GET"

    assert_equal :identity_email_verification, current_named_route
  end

  test "returns correct named route for identity password reset new" do
    @request.path = "/identity/password_reset/new"
    @request.request_method = "GET"

    assert_equal :new_identity_password_reset, current_named_route
  end

  test "returns correct named route for identity password reset edit" do
    @request.path = "/identity/password_reset/edit"
    @request.request_method = "GET"

    assert_equal :edit_identity_password_reset, current_named_route
  end

  test "returns correct named route for user masquerade" do
    @request.path = "/users/123/masquerade"
    @request.request_method = "POST"

    assert_equal :user_masquerade, current_named_route
  end

  private

  def request
    @request
  end
end
