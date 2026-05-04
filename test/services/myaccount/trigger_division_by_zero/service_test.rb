require "test_helper"

class Myaccount::TriggerDivisionByZero::ServiceTest < ActiveSupport::TestCase
  test "raises ZeroDivisionError" do
    assert_raises(ZeroDivisionError) do
      Myaccount::TriggerDivisionByZero::Service.call(numerator: 1)
    end
  end
end
