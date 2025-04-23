class SessionsController < ApplicationController
  skip_before_action :authenticate, only: %i[ new create ]
  skip_authorization only: %i[ new create ]
  before_action :find_bot, only: :create
  before_action :set_session, only: :destroy

  # @route GET /sign_in (sign_in)
  def new
  end

  # @route POST /sign_in (sign_in)
  def create
    if user = User.authenticate_by(email: params[:email], password: params[:password])
      @session = user.sessions.create!
      cookies.signed.permanent[:session_token] = { value: @session.id, httponly: true }

      redirect_to myaccount_path, notice: "Signed in successfully"
    else
      redirect_to sign_in_path(email_hint: params[:email]), alert: "That email or password is incorrect"
    end
  end

  # @route DELETE /sessions/:id (session)
  def destroy
    @session.destroy; redirect_to(myaccount_sessions_path, notice: "That session has been logged out")
  end

  private
    def set_session
      @session = Current.user.sessions.find(params[:id])
    end
end
