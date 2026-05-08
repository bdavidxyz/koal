class Identity::PasswordResetsController < ApplicationController
  grant_access action: :new
  # @route GET /identity/password_reset/new (new_identity_password_reset)
  def new
  end

  grant_access action: :edit
  # @route GET /identity/password_reset/edit (edit_identity_password_reset)
  def edit
    @result = Identity::PasswordResets::Edit::Service.call(
      sid: params[:sid]
    )

    if @result.failure?
      redirect_to new_identity_password_reset_path, alert: "That password reset link is invalid"
    end
  end

  grant_access action: :create
  # @route POST /identity/password_reset (identity_password_reset)
  def create
    @result = Identity::PasswordResets::Create::Service.call(
      email: params[:email]
    )

    if @result.success?
      redirect_to sign_in_path, notice: "Check your email for reset instructions"
    else
      redirect_to new_identity_password_reset_path, alert: "You can’t reset your password until you verify your email"
    end
  end

  grant_access action: :update
  # @route PATCH /identity/password_reset (identity_password_reset)
  # @route PUT /identity/password_reset (identity_password_reset)
  def update
    @result = Identity::PasswordResets::Update::Service.call(
      sid: params[:sid],
      password: params[:password],
      password_confirmation: params[:password_confirmation]
    )

    if @result.success?
      redirect_to sign_in_path, notice: "Your password was reset successfully. Please sign in"
    elsif @result.error.class == Servus::Support::Errors::NotFoundError
      redirect_to new_identity_password_reset_path, alert: "That password reset link is invalid"
    else
      render :edit, status: :unprocessable_content
    end
  end
end
