module MyaccountRoles::Update
  class Service < Servus::Base
    def initialize(id:, attributes:)
      @id = id
      @attributes = attributes
    end

    def call
      role = Rabarber::Role.find_by(id: @id)
      return failure("Role not found", type: NotFoundError) unless role

      return failure("Role could not be updated", data: { role: role }) unless role.update(@attributes)

      success(role: role)
    end
  end
end
