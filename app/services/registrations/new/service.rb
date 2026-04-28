module Registrations::New
  class Service < Servus::Base
    def initialize
    end

    def call
      success(user: User.new)
    end
  end
end
