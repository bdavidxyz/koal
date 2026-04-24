module MyaccountUsers::Edit
  class Service < Servus::Base
    def initialize(slug:)
      @slug = slug
    end

    def call
      user = User.find_by(slug: @slug)
      return failure("User not found", type: NotFoundError) unless user

      success(user: user)
    end
  end
end
