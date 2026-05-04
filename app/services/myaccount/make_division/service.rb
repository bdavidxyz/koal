module Myaccount::MakeDivision
  class Service < Servus::Base
    def initialize(numerator:, denominator:)
      @numerator = numerator
      @denominator = denominator
    end

    def call
      result = @numerator / @denominator
      success(result: result)
    end
  end
end
