module Sessions::Create
  class Service < Servus::Base
    def initialize(email:, password:, cookies:)
      @email = email
      @password = password
      @cookies = cookies
    end

    def call
      user = User.authenticate_by(email: @email, password: @password)
      return invalid_credentials unless user

      session_record = user.sessions.create!
      @cookies.signed.permanent[:session_token] = { value: session_record.id, httponly: true }

      success(session: session_record)
    end

    private
      def invalid_credentials
        failure(
          "That email or password is incorrect",
          data: { email_hint: @email },
          type: Servus::Support::Errors::AuthenticationError
        )
      end
  end
end
