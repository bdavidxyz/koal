require "test_helper"

class CurrentRouteHelperTest < ActionView::TestCase
  include CurrentRouteHelper

  # Remove any existing myrequest method to avoid conflicts
  undef :request if method_defined?(:request)

  test "should return nil when no myrequest path" do
    # Create a mock myrequest object with no path
    myrequest = Struct.new(:path, :method_symbol).new(nil, :get)
    assert_nil current_named_route(myrequest)
  end

  test "should return nil for unrecognized route" do
    # Create a mock myrequest object with an unrecognized path
    myrequest = Struct.new(:path, :method_symbol).new("/nonexistent/path", :get)
    assert_nil current_named_route(myrequest)
  end

  test "should return correct route name for root path" do
    # Create a mock myrequest object for root path
    myrequest = Struct.new(:path, :method_symbol).new("/", :get)
    result = current_named_route(myrequest)
    # The helper returns the first matching route, which is home_index for /
    assert_equal :home_index, result
  end

  test "should return correct route name for sign in page (GET)" do
    # Create a mock myrequest object for sign in page (GET)
    myrequest = Struct.new(:path, :method_symbol).new("/sign_in", :get)
    result = current_named_route(myrequest)
    assert_equal :sign_in, result
  end

  test "should return nil for sign in page (POST) as it has no named route" do
    # Create a mock myrequest object for sign in page (POST)
    myrequest = Struct.new(:path, :method_symbol).new("/sign_in", :post)
    result = current_named_route(myrequest)
    assert_nil result
  end

  test "should return nil and not raise error for routing error" do
    # Create a mock myrequest that will cause a routing error
    myrequest = Struct.new(:path, :method_symbol).new("/malformed/path/with/invalid/characters/!@#$%", :get)
    assert_nothing_raised do
      result = current_named_route(myrequest)
      assert_nil result
    end
  end
end
