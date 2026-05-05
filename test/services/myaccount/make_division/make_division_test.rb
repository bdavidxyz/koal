require "test_helper"

class Myaccount::MakeDivision::MakeDivisionTest < ActiveSupport::TestCase
  test "divides two positive numbers successfully" do
    result = Myaccount::MakeDivision::Service.call(numerator: 10, denominator: 2)

    assert result.success?
    assert_equal 5, result.data[:result]
  end

  test "divides negative by positive number successfully" do
    result = Myaccount::MakeDivision::Service.call(numerator: -10, denominator: 2)

    assert result.success?
    assert_equal(-5, result.data[:result])
  end

  test "divides positive by negative number successfully" do
    result = Myaccount::MakeDivision::Service.call(numerator: 10, denominator: -2)

    assert result.success?
    assert_equal(-5, result.data[:result])
  end

  test "divides two negative numbers successfully" do
    result = Myaccount::MakeDivision::Service.call(numerator: -10, denominator: -2)

    assert result.success?
    assert_equal 5, result.data[:result]
  end

  test "divides zero by non-zero number successfully" do
    result = Myaccount::MakeDivision::Service.call(numerator: 0, denominator: 5)

    assert result.success?
    assert_equal 0, result.data[:result]
  end

  test "raises ZeroDivisionError when dividing by zero" do
    assert_raises(ZeroDivisionError) do
      Myaccount::MakeDivision::Service.call(numerator: 10, denominator: 0)
    end
  end

  test "performs integer division" do
    result = Myaccount::MakeDivision::Service.call(numerator: 7, denominator: 2)

    assert result.success?
    assert_equal 3, result.data[:result]
  end
end
