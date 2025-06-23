class Identity::EmailVerificationsController < ApplicationController
  before_action :set_user, only: :show

  grant_access action: :show
  # @route GET /identity/email_verification (identity_email_verification)
  def show
    @user.update! verified: true
    redirect_to myaccount_path, notice: "Thank you for verifying your email address"
  end

  grant_access action: :create, roles: [ :member ]
  # @route POST /identity/email_verification (identity_email_verification)
  def create
    send_email_verification
    redirect_to myaccount_path, notice: "We sent a verification email to your email address"
  end

  private
    def set_user
      @user = User.find_by_token_for!(:email_verification, params[:sid])
    rescue StandardError
      redirect_to myaccount_path, alert: "That email verification link is invalid"
    end

    def send_email_verification
      UserMailer.with(user: Current.user).email_verification.deliver_later
    end
end
