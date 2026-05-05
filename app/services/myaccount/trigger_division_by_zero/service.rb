module Myaccount::TriggerDivisionByZero
  class Service < Servus::Base
    def initialize(numerator:)
      @numerator = numerator
    end

    def call
      result = Myaccount::MakeDivision::Service.call(numerator: @numerator, denominator: 0)
      # :nocov:
      success(result: result)
      # :nocov:
    end
  end
end
