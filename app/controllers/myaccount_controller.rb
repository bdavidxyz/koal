class MyaccountController < ApplicationController
  grant_access roles: :member

  # @route GET /myaccount (myaccount)
  def index
    session = Current.session
    u = Current.user
    sessions = u.sessions
    render locals: {
      email: u.email,
      session: session,
      session_number: u.sessions.order(created_at: :desc)
    }
  end
  # @route GET /myaccount/sessions (myaccount_sessions)
  def sessions
    render locals: {
      sessions: Current.user.sessions.order(created_at: :desc)
    }
  end
  # @route GET /myaccount/email (myaccount_email)
  def email
    render locals: {
      user: Current.user
    }
  end
  # @route GET /myaccount/password (myaccount_password)
  def password
    render locals: {
      user: Current.user
    }
  end
  # @route GET /myaccount/profile (myaccount_profile)
  def profile
    render locals: {
      user: Current.user
    }
  end
  # @route DELETE /myaccount/destroy (myaccount_destroy)
  def destroy_account
    user = Current.user
    Current.session.destroy
    user.destroy
    redirect_to root_path, notice: "You account has been deleted."
  end
end
