module Identity::PasswordResets::Update
  class Service < Servus::Base
    def initialize(sid:, password:, password_confirmation:)
      @sid = sid
      @password = password
      @password_confirmation = password_confirmation
    end

    def call
      user = User.find_by_token_for!(:password_reset, @sid)

      if user.update(password: @password, password_confirmation: @password_confirmation)
        success(user: user)
      else
        failure(
          "Password update failed",
          data: { user: user },
          type: ValidationError
        )
      end
    rescue StandardError
      failure(
        "That password reset link is invalid",
        type: NotFoundError
      )
    end
  end
end
