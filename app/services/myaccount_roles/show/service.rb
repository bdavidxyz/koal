module MyaccountRoles::Show
  class Service < Servus::Base
    def initialize(id:)
      @id = id
    end

    def call
      role = Rabarber::Role.find_by(id: @id)
      return failure("Role not found", type: NotFoundError) unless role

      success(role: role)
    end
  end
end
