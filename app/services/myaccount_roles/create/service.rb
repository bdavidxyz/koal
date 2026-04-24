module MyaccountRoles::Create
  class Service < Servus::Base
    def initialize(attributes:)
      @attributes = attributes
    end

    def call
      role = Rabarber::Role.new(@attributes)
      return failure("Role could not be created", data: { role: role }) unless role.save

      success(role: role)
    end
  end
end
