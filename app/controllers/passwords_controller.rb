class PasswordsController < ApplicationController
  before_action :set_user

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to myaccount_path, notice: "Your password has been changed"
    else
      # Below also works with flash message, not that the template is rendered within the layout, thus it works
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
