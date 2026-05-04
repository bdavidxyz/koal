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
    assert_equal :log_file, result.data[:source]
    assert_equal "#{Rails.env} log file", result.data[:source_label]
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

  test "returns unique request ids from solid errors occurrences" do
    occurrences = [
      Struct.new(:context, :created_at).new({ "request_id" => "older-error" }, 2.hours.ago),
      Struct.new(:context, :created_at).new({ "request_id" => "newer-error" }, 1.hour.ago),
      Struct.new(:context, :created_at).new({ "request_id" => "older-error" }, Time.current),
      Struct.new(:context, :created_at).new({ "other_key" => "ignored" }, 30.minutes.ago)
    ]

    result = Myaccount::Errors::Index::Service.call(source: :solid_errors, occurrences: occurrences)

    assert result.success?
    assert_equal [ "older-error", "newer-error" ], result.data[:request_ids]
    assert_equal :solid_errors, result.data[:source]
    assert_equal "Solid Errors occurrences", result.data[:source_label]
    assert_equal "solid_errors_occurrences.context.request_id", result.data[:source_location]
  end
end
