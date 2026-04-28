module Registrations::Create
  class Service < Servus::Base
    def initialize(attributes:, cookies:)
      @attributes = attributes
      @cookies = cookies
    end

    def call
      @user = User.new(@attributes)

      if @user.save
        session_record = @user.sessions.create!
        SessionCookie.new(@cookies).value = session_record.id

        send_email_verification
        success(user: @user)
      else
        failure("User could not be created", data: { user: @user })
      end
    end

    private

    def send_email_verification
      UserMailer.with(user: @user).email_verification.deliver_later
    end
  end
end
