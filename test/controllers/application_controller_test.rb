require "test_helper"

class TestErrorPagesController < ApplicationController
  skip_authorization
  skip_before_action :set_current_request_details
  skip_before_action :set_current_session
  skip_before_action :check_authentication_requirement
  skip_after_action :track_page_view

  def show
    render_error_page(params[:code], params[:message])
  end

  def show_symbol
    render_error_page(:not_found, params[:message])
  end
end

class ApplicationControllerTest < ActionController::TestCase
  tests TestErrorPagesController

  setup do
    @routes = ActionDispatch::Routing::RouteSet.new
    @routes.draw do
      get "/show", to: "test_error_pages#show"
      get "/show_symbol", to: "test_error_pages#show_symbol"
    end
  end

  test "render_error_page renders a dynamic error page for valid HTTP error codes" do
    get :show, params: { code: 451, message: "Custom legal restriction message" }

    assert_response 451
    assert_match "451", response.body
    assert_match "Unavailable For Legal Reasons", response.body
    assert_match "Custom legal restriction message", response.body
  end

  test "render_error_page accepts status symbols" do
    get :show_symbol, params: { message: "Missing page" }

    assert_response :not_found
    assert_match "404", response.body
    assert_match "Not Found", response.body
    assert_match "Missing page", response.body
  end

  test "render_error_page raises for codes outside the supported HTTP error range" do
    assert_raises(ArgumentError) do
      get :show, params: { code: 399, message: "Out of range" }
    end
  end
end
