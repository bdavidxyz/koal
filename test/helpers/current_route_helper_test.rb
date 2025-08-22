require "test_helper"

class CurrentRouteHelperTest < ActionView::TestCase
  include CurrentRouteHelper

  test "should return nil when request is not defined" do
    # Ensure no request is available
    undef :request if respond_to?(:request)

    assert_nil current_named_route
  end

  test "should return nil when request path is nil" do
    mock_request = mock_request_with_path(nil, :get)
    stub_request(mock_request)

    assert_nil current_named_route
  end

  test "should return home_index when request path is empty" do
    mock_request = mock_request_with_path("", :get)
    stub_request(mock_request)

    # Empty path is treated as root path by Rails routing
    assert_equal :home_index, current_named_route
  end

  test "should return correct route name for root path" do
    mock_request = mock_request_with_path("/", :get)
    stub_request(mock_request)

    result = current_named_route
    assert_equal :home_index, result
  end

  test "should return correct route name for sign in page" do
    mock_request = mock_request_with_path("/sign_in", :get)
    stub_request(mock_request)

    result = current_named_route
    assert_equal :sign_in, result
  end

  test "should return nil for unrecognized route" do
    mock_request = mock_request_with_path("/nonexistent/path", :get)
    stub_request(mock_request)

    assert_nil current_named_route
  end

  test "should handle different HTTP methods" do
    # Test GET method
    mock_request = mock_request_with_path("/", :get)
    stub_request(mock_request)
    assert_equal :home_index, current_named_route

    # Test POST method (assuming sign_in POST has no named route)
    mock_request = mock_request_with_path("/sign_in", :post)
    stub_request(mock_request)
    result = current_named_route
    # POST to sign_in typically doesn't have a named route, so should be nil
    assert_nil result
  end

  test "should handle routing errors gracefully" do
    mock_request = mock_request_with_path("/malformed/path/with/invalid/characters/!@#$%", :get)
    stub_request(mock_request)

    # Should not raise an error and should return nil
    assert_nothing_raised do
      result = current_named_route
      assert_nil result
    end
  end

  test "should match route defaults correctly" do
    # Test a more complex route like myaccount
    mock_request = mock_request_with_path("/myaccount", :get)
    stub_request(mock_request)

    result = current_named_route
    # This should match the myaccount route
    assert_equal :myaccount, result
  end

  test "should handle routing error and return nil" do
    # Test with a path that will cause routing issues
    mock_request = mock_request_with_path("/invalid-characters-symbols", :get)
    stub_request(mock_request)

    # Should handle the error gracefully and return nil
    assert_nothing_raised do
      result = current_named_route
      assert_nil result
    end
  end


  private

  def mock_request_with_path(path, method_symbol)
    request = Object.new
    request.define_singleton_method(:path) { path }
    request.define_singleton_method(:method_symbol) { method_symbol }
    request
  end

  def stub_request(mock_request)
    define_singleton_method(:request) { mock_request }
  end
end
