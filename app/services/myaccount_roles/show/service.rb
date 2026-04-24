module MyaccountRoles::Show
  class Service < Servus::Base
    def initialize(id:)
      @id = id
    end

    def call
      role = Rabarber::Role.find_by(id: @id)
      return role_not_found unless role

      success(role: role)
    end

    private
      def role_not_found
        failure(
          "Role not found",
          type: NotFoundError
        )
      end
  end
end
