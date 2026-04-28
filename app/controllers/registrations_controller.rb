class RegistrationsController < ApplicationController
  before_action :find_bot, only: :create

  grant_access action: :new
  # @route GET /sign_up (sign_up)
  def new
    @result = Registrations::New::Service.call
  end

  grant_access action: :create
  # @route POST /sign_up (sign_up)
  def create
    @result = Registrations::Create::Service.call(
      attributes: user_params,
      cookies: cookies
    )

    if @result.success?
      redirect_to myaccount_email_path, notice: "Welcome! You have signed up successfully"
    else
      render :new, status: :unprocessable_content
    end
  end

  private
    def user_params
      params.permit(:email, :password, :password_confirmation)
    end
end
