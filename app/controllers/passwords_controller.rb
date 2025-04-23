class PasswordsController < ApplicationController
  before_action :set_user
  grant_access roles: :member

  def edit
  end

  # @route PATCH /password (password)
  # @route PUT /password (password)
  def update
    if @user.update(user_params)
      redirect_to myaccount_path, notice: "Your password has been changed"
    else
      render partial: "myaccount/myaccount_password", status: :unprocessable_entity, locals: {
        user: @user
      }

      # Below also works with flash message, not that the template is rendered within the layout,
      # Thus rendering the flash as expected
      #
      # flash.now[:alert] = "Error occured"
      # render :update, status: :unprocessable_entity, locals: { user: @user }
    end
  end

  private
    def set_user
      @user = Current.user
    end

    def user_params
      params.permit(:password, :password_confirmation, :password_challenge).with_defaults(password_challenge: "")
    end
end
