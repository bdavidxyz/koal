class SessionsController < ApplicationController
  before_action :find_bot, only: :create
  before_action :set_session, only: :destroy

  grant_access action: :new
  # @route GET /sign_in (sign_in)
  def new
  end

  grant_access action: :create
  # @route POST /sign_in (sign_in)
  def create
    run_service(
      Sessions::Create::Service,
      email: params[:email],
      password: params[:password],
      cookies: cookies,
    )

    return if performed? || @result.failure?

    redirect_to myaccount_path, notice: "Signed in successfully"
  end

  require_auth action: :destroy
  grant_access action: :destroy, roles: [ :member ]
  # @route DELETE /sessions/:id (session)
  def destroy
    @session.destroy; redirect_to(myaccount_sessions_path, notice: "That session has been logged out")
  end

  private
    def render_service_error(error)
      if error.is_a?(Servus::Support::Errors::AuthenticationError)
        redirect_to sign_in_path(email_hint: @result.data[:email_hint]), alert: error.message
        return
      end

      super
    end

    def set_session
      @session = Current.user.sessions.find(params[:id])
    end
end
