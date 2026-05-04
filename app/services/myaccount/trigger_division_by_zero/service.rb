module Myaccount::TriggerDivisionByZero
  class Service < Servus::Base
    def initialize(numerator:)
      @numerator = numerator
    end

    def call
      result = @numerator / 0
      success(result: result)
    end
  end
end
