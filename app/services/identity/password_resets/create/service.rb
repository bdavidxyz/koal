module Identity::PasswordResets::Create
  class Service < Servus::Base
    def initialize(email:)
      @email = email
    end

    def call
      user = User.find_by(email: @email, verified: true)

      if user
        UserMailer.with(user: user).password_reset.deliver_later
        success(user: user)
      else
        failure(
          "You can't reset your password until you verify your email",
          type: ValidationError
        )
      end
    end
  end
end
