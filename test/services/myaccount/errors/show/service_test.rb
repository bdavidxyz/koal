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

  test "filters solid errors persistence lines including related transactions" do
    log_file = Tempfile.new("myaccount-errors-show")
    log_file.write <<~LOG
      [target-request] Started POST /myaccount/adminpanel/trigger_division_by_zero
      [target-request] SolidErrors::Error Load (0.1ms) SELECT "solid_errors".* FROM "solid_errors" WHERE "solid_errors"."id" = 1 LIMIT 1
      [target-request] TRANSACTION (0.0ms) BEGIN immediate TRANSACTION
      [target-request] SolidErrors::Occurrence Create (0.2ms) INSERT INTO "solid_errors_occurrences" ("error_id") VALUES (1)
      [target-request] TRANSACTION (0.2ms) COMMIT TRANSACTION
      [target-request]
      [target-request] ZeroDivisionError (divided by 0):
      [target-request] app/services/myaccount/make_division/service.rb:9:in 'Integer#/'
    LOG
    log_file.flush

    result = Myaccount::Errors::Show::Service.call(request_id: "target-request", log_path: log_file.path)

    assert result.success?
    assert_equal 4, result.data[:lines].size
    assert result.data[:lines].none? { |entry| entry[:content].match?(/SolidErrors|solid_errors|TRANSACTION/) }
    assert_equal "[target-request] ZeroDivisionError (divided by 0):", result.data[:lines][-2][:content]
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
