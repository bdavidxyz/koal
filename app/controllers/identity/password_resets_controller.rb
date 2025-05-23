class Identity::PasswordResetsController < ApplicationController
  before_action :set_user, only: %i[ edit update ]

  grant_access action: :new
  # @route GET /identity/password_reset/new (new_identity_password_reset)
  def new
  end

  grant_access action: :edit
  # @route GET /identity/password_reset/edit (edit_identity_password_reset)
  def edit
  end

  grant_access action: :create
  # @route POST /identity/password_reset (identity_password_reset)
  def create
    if @user = User.find_by(email: params[:email], verified: true)
      send_password_reset_email
      redirect_to sign_in_path, notice: "Check your email for reset instructions"
    else
      redirect_to new_identity_password_reset_path, alert: "You can’t reset your password until you verify your email"
    end
  end

  grant_access action: :update
  # @route PATCH /identity/password_reset (identity_password_reset)
  # @route PUT /identity/password_reset (identity_password_reset)
  def update
    if @user.update(user_params)
      redirect_to sign_in_path, notice: "Your password was reset successfully. Please sign in"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private
    def set_user
      @user = User.find_by_token_for!(:password_reset, params[:sid])
    rescue StandardError
      redirect_to new_identity_password_reset_path, alert: "That password reset link is invalid"
    end

    def user_params
      params.permit(:password, :password_confirmation)
    end

    def send_password_reset_email
      UserMailer.with(user: @user).password_reset.deliver_later
    end
end
