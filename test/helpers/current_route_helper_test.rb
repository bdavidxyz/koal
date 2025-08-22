require "test_helper"

class CurrentRouteHelperTest < ActionView::TestCase
  include CurrentRouteHelper

  # Remove any existing request method to avoid conflicts
  undef :request if method_defined?(:request)

  test "should return nil when no request path" do
    # Create a mock request object with no path
    request = Struct.new(:path, :method_symbol).new(nil, :get)
    assert_nil current_named_route(request)
  end

  test "should return nil for unrecognized route" do
    # Create a mock request object with an unrecognized path
    request = Struct.new(:path, :method_symbol).new("/nonexistent/path", :get)
    assert_nil current_named_route(request)
  end

  test "should return correct route name for root path" do
    # Create a mock request object for root path
    request = Struct.new(:path, :method_symbol).new("/", :get)
    result = current_named_route(request)
    # The helper returns the first matching route, which is home_index for /
    assert_equal :home_index, result
  end

  test "should return correct route name for chronicles index" do
    # Create a mock request object for chronicles index
    request = Struct.new(:path, :method_symbol).new("/chronicles", :get)
    result = current_named_route(request)
    assert_equal :chronicles, result
  end

  test "should return correct route name for chronicle show" do
    # Create a mock request object for chronicle show
    request = Struct.new(:path, :method_symbol).new("/chronicles/some-slug", :get)
    result = current_named_route(request)
    assert_equal :chronicle, result
  end

  test "should return correct route name for sign in page (GET)" do
    # Create a mock request object for sign in page (GET)
    request = Struct.new(:path, :method_symbol).new("/sign_in", :get)
    result = current_named_route(request)
    assert_equal :sign_in, result
  end

  test "should return nil for sign in page (POST) as it has no named route" do
    # Create a mock request object for sign in page (POST)
    request = Struct.new(:path, :method_symbol).new("/sign_in", :post)
    result = current_named_route(request)
    assert_nil result
  end

  test "should return correct route name for sign up page (GET)" do
    # Create a mock request object for sign up page (GET)
    request = Struct.new(:path, :method_symbol).new("/sign_up", :get)
    result = current_named_route(request)
    assert_equal :sign_up, result
  end

  test "should return nil for sign up page (POST) as it has no named route" do
    # Create a mock request object for sign up page (POST)
    request = Struct.new(:path, :method_symbol).new("/sign_up", :post)
    result = current_named_route(request)
    assert_nil result
  end

  test "should return correct route name for myaccount page" do
    # Create a mock request object for myaccount page
    request = Struct.new(:path, :method_symbol).new("/myaccount", :get)
    result = current_named_route(request)
    assert_equal :myaccount, result
  end

  test "should handle myaccount users routes" do
    # Create a mock request object for myaccount users list
    request = Struct.new(:path, :method_symbol).new("/myaccount/users", :get)
    result = current_named_route(request)
    assert_equal :myaccount_user_list, result
  end

  test "should handle myaccount chronicles routes" do
    # Create a mock request object for myaccount chronicles list
    request = Struct.new(:path, :method_symbol).new("/myaccount/chronicles", :get)
    result = current_named_route(request)
    assert_equal :myaccount_chronicle_list, result
  end

  test "should return nil and not raise error for routing error" do
    # Create a mock request that will cause a routing error
    request = Struct.new(:path, :method_symbol).new("/malformed/path/with/invalid/characters/!@#$%", :get)
    assert_nothing_raised do
      result = current_named_route(request)
      assert_nil result
    end
  end
end