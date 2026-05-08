class PasswordsController < ApplicationController
  #
  require_auth action: :update
  grant_access action: :update, roles: [ :member ]
  # @route PATCH /password (password)
  # @route PUT /password (password)
  def update
    @result = Passwords::Update::Service.call(
      user: Current.user,
      password: params[:password],
      password_confirmation: params[:password_confirmation],
      password_challenge: params[:password_challenge] || ""
    )

    if @result.success?
      redirect_to myaccount_path, notice: "Your password has been changed"
    else
      render partial: "myaccount/myaccount_password", status: :unprocessable_content
    end
  end
end
