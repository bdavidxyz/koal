module MyaccountRoles::New
  class Service < Servus::Base
    def call
      success(role: Rabarber::Role.new)
    end
  end
end
