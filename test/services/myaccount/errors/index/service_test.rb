require "test_helper"

class Myaccount::Errors::Index::ServiceTest < ActiveSupport::TestCase
  test "returns unique error request ids ordered by latest match first" do
    log_file = Tempfile.new("myaccount-errors")
    log_file.write <<~LOG
      [healthy-request] method=GET path=/myaccount status=200 duration=1.2
      [first-error] Myaccount::TriggerDivisionByZero::Service uncaught exception: ZeroDivisionError - divided by 0
      [second-error] method=POST path=/danger status=500 duration=4.2
      [first-error] Completed 500 Internal Server Error in 5ms
    LOG
    log_file.flush

    result = Myaccount::Errors::Index::Service.call(log_path: log_file.path)

    assert result.success?
    assert_equal [ "first-error", "second-error" ], result.data[:request_ids]
    assert_equal log_file.path, result.data[:log_path]
    assert_equal Rails.env, result.data[:environment]
  ensure
    log_file.close!
  end

  test "returns an empty list when the log file does not exist" do
    missing_log_path = Rails.root.join("tmp", "missing-errors-#{Process.pid}-#{object_id}.log")

    result = Myaccount::Errors::Index::Service.call(log_path: missing_log_path)

    assert result.success?
    assert_equal [], result.data[:request_ids]
    assert_equal missing_log_path.to_s, result.data[:log_path]
  end
end
