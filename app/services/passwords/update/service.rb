module Passwords::Update
  class Service < Servus::Base
    def initialize(user:, password:, password_confirmation:, password_challenge:)
      @user = user
      @password = password
      @password_confirmation = password_confirmation
      @password_challenge = password_challenge
    end

    def call
      if @user.update(password_params)
        success(user: @user)
      else
        failure(
          "Password update failed",
          data: { user: @user },
          type: ValidationError
        )
      end
    end

    private
      def password_params
        {
          password: @password,
          password_confirmation: @password_confirmation,
          password_challenge: @password_challenge
        }
      end
  end
end
