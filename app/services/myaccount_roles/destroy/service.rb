module MyaccountRoles::Destroy
  class Service < Servus::Base
    def initialize(id:)
      @id = id
    end

    def call
      role = Rabarber::Role.find_by(id: @id)
      return failure("Role not found", type: NotFoundError) unless role

      return failure("Role could not be deleted", data: { role: role }) unless destroy(role)

      success(role: role)
    end

    private
      def destroy(role)
        role.destroy
        role.destroyed?
      end
  end
end
