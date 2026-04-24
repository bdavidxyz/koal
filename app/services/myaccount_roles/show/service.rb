module MyaccountRoles::Show
  class Service < Servus::Base
    def initialize(id:)
      @id = id
    end

    def call
      role = Rabarber::Role.find_by(id: @id)
      return role_not_found unless role

      success(
        role: role,
        controller_method: :render_role_show,
        controller_args: [ role ]
      )
    end

    private
      def role_not_found
        failure(
          "Role not found",
          data: {
            controller_method: :not_found,
            controller_args: []
          },
          type: Servus::Support::Errors::NotFoundError
        )
      end
  end
end
