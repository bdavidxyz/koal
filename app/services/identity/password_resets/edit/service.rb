module Identity::PasswordResets::Edit
  class Service < Servus::Base
    def initialize(sid:)
      @sid = sid
    end

    def call
      user = User.find_by_token_for!(:password_reset, @sid)
      success(user: user)
    rescue StandardError
      failure(
        "That password reset link is invalid",
        type: NotFoundError
      )
    end
  end
end
