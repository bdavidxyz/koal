class RegistrationsController < ApplicationController
  before_action :find_bot, only: :create


  no_auth_for :new
  # @route GET /sign_up (sign_up)
  def new
    @user = User.new
  end

  no_auth_for :create
  # @route POST /sign_up (sign_up)
  def create
    @user = User.new(user_params)
    if @user.save
      session_record = @user.sessions.create!
      cookies.signed.permanent[:session_token] = { value: session_record.id, httponly: true }

      send_email_verification
      redirect_to myaccount_email_path, notice: "Welcome! You have signed up successfully"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private
    def user_params
      params.permit(:email, :password, :password_confirmation)
    end

    def send_email_verification
      UserMailer.with(user: @user).email_verification.deliver_later
    end
end
