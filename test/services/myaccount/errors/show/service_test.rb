require "test_helper"

class Myaccount::Errors::Show::ServiceTest < ActiveSupport::TestCase
  test "returns log lines for request id sorted by line number descending" do
    log_file = Tempfile.new("myaccount-errors-show")
    log_file.write <<~LOG
      [healthy-request] method=GET path=/myaccount status=200 duration=1.2
      [target-request] Started GET /myaccount
      [other-request] Completed 500 Internal Server Error in 3ms
      [target-request] Processing by MyaccountController#index
      [target-request] Completed 200 OK in 12ms
    LOG
    log_file.flush

    result = Myaccount::Errors::Show::Service.call(request_id: "target-request", log_path: log_file.path)

    assert result.success?
    assert_equal "target-request", result.data[:request_id]
    assert_equal 3, result.data[:lines].size
    assert result.data[:lines].first[:index] < result.data[:lines].last[:index]
    assert result.data[:lines].all? { |entry| entry[:content].include?("[target-request]") }
  ensure
    log_file.close!
  end

  test "matches lines where request id is preceded by a rails logger prefix" do
    log_file = Tempfile.new("myaccount-errors-show")
    log_file.write <<~LOG
      I, [2026-05-04T09:00:00.000000 #123]  INFO -- : [target-request] Calling SomeService with args: {numerator: 33}
      [target-request] Completed 200 OK in 12ms
    LOG
    log_file.flush

    result = Myaccount::Errors::Show::Service.call(request_id: "target-request", log_path: log_file.path)

    assert result.success?
    assert_equal 2, result.data[:lines].size
    assert result.data[:lines].all? { |entry| entry[:content].include?("[target-request]") }
  ensure
    log_file.close!
  end

  test "raises NotFoundError when request id has no matching lines" do
    log_file = Tempfile.new("myaccount-errors-show")
    log_file.write <<~LOG
      [healthy-request] method=GET path=/myaccount status=200 duration=1.2
    LOG
    log_file.flush

    result = Myaccount::Errors::Show::Service.call(request_id: "nonexistent-id", log_path: log_file.path)

    assert_not result.success?
    assert_equal :not_found, result.error.http_status
  ensure
    log_file.close!
  end

  test "raises NotFoundError when log file does not exist" do
    missing_log_path = Rails.root.join("tmp", "missing-show-#{Process.pid}-#{object_id}.log")

    result = Myaccount::Errors::Show::Service.call(request_id: "any-id", log_path: missing_log_path)

    assert_not result.success?
    assert_equal :not_found, result.error.http_status
  end
end
