require "test_helper"

class MyaccountAdminpanelControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = sign_in_as(users(:jane))
  end

  test "should get adminpanel" do
    get myaccount_adminpanel_url
    assert_response :success
  end

  test "should trigger hello world job" do
    assert_enqueued_with(job: HelloWorldJob) do
      post myaccount_adminpanel_trigger_hello_world_job_url
    end

    assert_redirected_to myaccount_adminpanel_url
    assert_equal "Hello World job triggered!", flash[:notice]
  end
end
