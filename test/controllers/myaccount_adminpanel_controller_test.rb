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

  test "should trigger division by zero" do
    assert_raises(ZeroDivisionError) do
      post myaccount_adminpanel_trigger_division_by_zero_url
    end
  end

  test "should get errors" do
    log_path = Rails.root.join("log", "#{Rails.env}.log")
    original_contents = File.exist?(log_path) ? File.binread(log_path) : nil
    File.write(log_path, <<~LOG)
      [cfdc26e0-c61d-4fb3-9b17-16c176eb098a] Myaccount::TriggerDivisionByZero::Service uncaught exception: ZeroDivisionError - divided by 0
      [healthy-request] method=GET path=/myaccount status=200 duration=0.5
    LOG

    get myaccount_errors_url

    assert_response :success
    assert_includes @response.body, "cfdc26e0-c61d-4fb3-9b17-16c176eb098a"
    assert_includes @response.body, "Errors"
  ensure
    if original_contents.nil?
      File.delete(log_path) if File.exist?(log_path)
    else
      File.binwrite(log_path, original_contents)
    end
  end

  test "member cannot access errors" do
    sign_in_as(users(:alicia))

    get myaccount_errors_url

    assert_response :not_found
  end
end
