require "test_helper"

class StyleguideControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get styleguide_path
    assert_response :success
  end
end
