require "test_helper"

class TestErrorableController < ActionController::Base
  include ErrorableController

  def show
    render_error_page(params[:code], params[:message])
  end

  def show_integer
    render_error_page(451, params[:message])
  end

  def show_symbol
    render_error_page(:not_found, params[:message])
  end

  def show_unknown_label
    render_error_page(499, params[:message])
  end

  def show_low_out_of_range
    render_error_page(399, params[:message])
  end

  def show_high_out_of_range
    render_error_page(512, params[:message])
  end

  def show_unknown_symbol
    render_error_page(:not_a_real_status, params[:message])
  end

  def unauthorized
    when_unauthorized
  end
end

class ErrorableControllerTest < ActionController::TestCase
  tests TestErrorableController

  setup do
    @routes = ActionDispatch::Routing::RouteSet.new
    @routes.draw do
      get "/show", to: "test_errorable#show"
      get "/show_integer", to: "test_errorable#show_integer"
      get "/show_symbol", to: "test_errorable#show_symbol"
      get "/show_unknown_label", to: "test_errorable#show_unknown_label"
      get "/show_low_out_of_range", to: "test_errorable#show_low_out_of_range"
      get "/show_high_out_of_range", to: "test_errorable#show_high_out_of_range"
      get "/show_unknown_symbol", to: "test_errorable#show_unknown_symbol"
      get "/unauthorized", to: "test_errorable#unauthorized"
    end
  end

  test "render_error_page renders a dynamic error page for string HTTP error codes" do
    get :show, params: { code: "451", message: "Custom legal restriction message" }

    assert_response 451
    assert_match "451", response.body
    assert_match "Unavailable For Legal Reasons", response.body
    assert_match "Custom legal restriction message", response.body
  end

  test "render_error_page accepts integer status codes" do
    get :show_integer, params: { message: "Integer code message" }

    assert_response 451
    assert_match "451", response.body
    assert_match "Unavailable For Legal Reasons", response.body
    assert_match "Integer code message", response.body
  end

  test "render_error_page accepts status symbols" do
    get :show_symbol, params: { message: "Missing page" }

    assert_response :not_found
    assert_match "404", response.body
    assert_match "Not Found", response.body
    assert_match "Missing page", response.body
  end

  test "render_error_page falls back to unknown error for unmapped status labels" do
    get :show_unknown_label, params: { message: "Unknown status label" }

    assert_equal 499, response.status
    assert_match "499", response.body
    assert_match "Unknown Error", response.body
    assert_match "Unknown status label", response.body
  end

  test "render_error_page raises for codes below the supported HTTP error range" do
    error = assert_raises(ArgumentError) do
      get :show_low_out_of_range, params: { message: "Out of range" }
    end

    assert_equal "HTTP error code must be between 400 and 511", error.message
  end

  test "render_error_page raises for codes above the supported HTTP error range" do
    error = assert_raises(ArgumentError) do
      get :show_high_out_of_range, params: { message: "Out of range" }
    end

    assert_equal "HTTP error code must be between 400 and 511", error.message
  end

  test "render_error_page raises for unknown status symbols" do
    error = assert_raises(ArgumentError) do
      get :show_unknown_symbol, params: { message: "Unknown symbol" }
    end

    assert_equal "Unknown HTTP status symbol: :not_a_real_status", error.message
  end

  test "render_error_page raises for invalid numeric status values" do
    assert_raises(ArgumentError) do
      get :show, params: { code: "not-a-code", message: "Invalid code" }
    end
  end
end
