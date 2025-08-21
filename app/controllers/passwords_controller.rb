class PasswordsController < ApplicationController
  #
  require_auth action: :update
  grant_access action: :update, roles: [ :member ]
  # @route PATCH /password (password)
  # @route PUT /password (password)
  def update
    @user = Current.user
    if @user.update(user_params)
      redirect_to myaccount_path, notice: "Your password has been changed"
    else
      render partial: "myaccount/myaccount_password", status: :unprocessable_content
      # Below also works with flash message, not that the template is rendered within the layout,
      # Thus rendering the flash as expected
      #
      # flash.now[:alert] = "Error occured"
      # render :update, status: :unprocessable_content
    end
  end

  private
    def user_params
      params.permit(:password, :password_confirmation, :password_challenge).with_defaults(password_challenge: "")
    end
end
