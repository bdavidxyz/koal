module Sessions::Create
  class Service < Servus::Base
    def initialize(email:, password:, cookies:)
      @email = email
      @password = password
      @cookies = cookies
    end

    def call
      user = User.authenticate_by(email: email, password: password)
      return invalid_credentials unless user

      session_record = user.sessions.create!
      cookies.signed.permanent[:session_token] = { value: session_record.id, httponly: true }

      success(
        session: session_record,
        controller_method: :dynamic_redirect_to,
        controller_args: [
          :myaccount_path,
          {},
          { notice: "Signed in successfully" }
        ]
      )
    end

    private
      attr_reader :email, :password, :cookies

      def invalid_credentials
        failure(
          "That email or password is incorrect",
          data: {
            controller_method: :dynamic_redirect_to,
            controller_args: [
              :sign_in_path,
              { email_hint: email },
              { alert: "That email or password is incorrect" }
            ]
          },
          type: Servus::Support::Errors::AuthenticationError
        )
      end
  end
end
