module MyaccountUsers::Update
  class Service < Servus::Base
    def initialize(slug:, attributes:, role_ids:)
      @slug = slug
      @attributes = attributes
      @role_ids = role_ids
    end

    def call
      user = User.find_by(slug: @slug)
      return failure("User not found", type: NotFoundError) unless user

      return failure("User could not be updated", data: { user: user }) unless persist(user)

      success(user: user)
    end

    private
      def persist(user)
        User.transaction do
          return false unless user.update(@attributes)

          sync_roles(user)
        end

        true
      end

      def sync_roles(user)
        user.revoke_all_roles

        selected_role_names.each do |role_name|
          user.assign_roles(role_name)
        end
      end

      def selected_role_names
        @selected_role_names ||= Rabarber::Role.where(id: normalized_role_ids).pluck(:name)
      end

      def normalized_role_ids
        Array(@role_ids).reject(&:blank?)
      end
  end
end
