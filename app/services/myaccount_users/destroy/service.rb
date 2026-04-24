module MyaccountUsers::Destroy
  class Service < Servus::Base
    def initialize(slug:)
      @slug = slug
    end

    def call
      user = User.find_by(slug: @slug)
      return failure("User not found", type: NotFoundError) unless user

      return failure("User could not be deleted", data: { user: user }) unless destroy(user)

      success(user: user)
    end

    private
      def destroy(user)
        user.destroy
        user.destroyed?
      end
  end
end
