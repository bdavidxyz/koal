require "test_helper"

class Myaccount::TriggerDivisionByZero::ServiceTest < ActiveSupport::TestCase
  test "raises ZeroDivisionError with positive numerator" do
    assert_raises(ZeroDivisionError) do
      Myaccount::TriggerDivisionByZero::Service.call(numerator: 1)
    end
  end

  test "raises ZeroDivisionError with negative numerator" do
    assert_raises(ZeroDivisionError) do
      Myaccount::TriggerDivisionByZero::Service.call(numerator: -5)
    end
  end

  test "raises ZeroDivisionError with zero numerator" do
    assert_raises(ZeroDivisionError) do
      Myaccount::TriggerDivisionByZero::Service.call(numerator: 0)
    end
  end

  test "raises ZeroDivisionError with large numerator" do
    assert_raises(ZeroDivisionError) do
      Myaccount::TriggerDivisionByZero::Service.call(numerator: 1000)
    end
  end
end
